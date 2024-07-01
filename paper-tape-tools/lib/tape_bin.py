import struct
from . import tape_common

class _BinReaderImpl:
    _DATA_FIELD_MASK    = 0o0070
    _BIT_78_MASK        = 0o0300

    _ignore_chars   = 0
    _data_field     = 0     # NOTE: actual binloader does self-modifying code bs and this would be an instruction.
    _addr           = 0
    _chr            = 0
    _chksum         = 0
    _word_half_one  = 0
    _word_half_two  = 0

    def _read_process_special_chars(self, ignore):
        ret = False

        # Write ignore characters flag.
        # This will always be zero within this class.
        self._ignore_chars = ignore

        while(True):
            # Read a character.
            new_char = self._read_character()

            # Check if read character has all bits set (is 0o377) by subtracting 0o376.
            # If all bits are set (result is greater than zero), we'll toggle the ignore flag.
            if(new_char - 0o376 > 0):
                # This is basically just "invert ignore," with 0 being false and 0o7777 being true.
                tmp = (ignore + 1) & 0o7777
                if(tmp == 0):
                    ignore = tmp ^ 0o7777

                # Write updated ignore flag.
                # NOTE: This was originally done by jumping to the start of this function.
                self._ignore_chars = ignore

                continue

            # Check if we should be ignoring new characters, ignore this character if we should be.
            if(self._ignore_chars != 0):
                continue
        
            # This sets up for the following two tests. If:
            # bits !7 & 8   -> 0o00
            # bits 7 & 8    -> 0o10
            # else          -> negative
            tmp = ((self._chr & self._BIT_78_MASK) - 0o200)

            # If bit 8 is not set (tmp < 0), set our return flag.
            # NOTE: This originally incremented the return address by 1, which allowed the caller to detect this case. But we can't do that here so we use the return value.
            if(tmp < 0):
                ret = True

            # If bits 7 & 8 are not both set at the same time (tmp <= 0), return to caller.
            if(tmp <= 0):
                return ret
            
            # Update data field index to the third octal part of the read word.
            # NOTE: This originally generated a modified CDFn0 instruction that would get used by main. We can't/shouldn't modify ourself so we store a data field index instead.
            self._data_field = (self._chr >> 6) & 0o7

    def _read_character(self):
        char = int.from_bytes(self._tape_fp.read(1))
        self._chr = char
        return char

    def _validate_checksum(self):
        # Read current word (should be the checksum at this point).
        # Subtract our word from our checksum, if valid the result will be zero.
        word = self._combine_chr()
        return self._chksum - word & 0o7777

    def _combine_chr(self):
        # Read first half word.
        word = self._word_half_one

        # Shift half word to the upper six positions.
        # NOTE: This was originally done with three 2x left shifts, we'll do one 6x shift for readability.
        word <<= 6

        # Read the second half word.
        word += self._word_half_two

        return word

    def read(self, tape_fp, writer_func):
        # Store tape file.
        self._tape_fp = tape_fp

        # NOTE: Here we would store the current data field, we're going to set it to zero. 
        self._data_field = 0

        # NOTE: Here the orignal binloader does a bunch of stuff to setup which tape reader is being used.

        print("here")

        # Loop the read & process function until we clear out all of the leader chars.
        done = False
        while(not done):
            done = self._read_process_special_chars(0)

        print("here")

        new_chksum = 0
        while(True):
            # Write our new checksum.
            self._chksum = new_chksum

            # NOTE: Here we would write the data field instruction.

            # Copy the first half word read by read_process_special_chars to _word_half_one.
            self._word_half_one = self._chr

            # Read a second character and store it to _word_half_two.
            self._word_half_two = self._read_character()

            # Read another new character with processing.
            # This will be the first half of the next word.
            # If a leader character is encountered the current word is our target checksum, which we will validate.
            # NOTE: Originally the validate function would exit, we obviously don't want to do that.
            if(self._read_process_special_chars(0) == False):
                return self._validate_checksum()

            # Combine both halves of the read word.
            combined = self._combine_chr()

            # Save the current word as an address if bit 13 (NOTE: link bit) is set.
            if(combined & 0o10000):
                self._addr = combined & 0o7777
                print(oct(self._addr))
            
            # Otherwise write the current word to _addr in _data_field then increment addr.
            else:
                writer_func(self._data_field, self._addr, combined)
                self._addr += 1
                if(self._addr > 0o7777):
                    self._addr = 0

            # Update our checksum with the two newly read chars.
            new_chksum = self._chksum + self._word_half_one + self._word_half_two

def read_tape(tape_fp, writer_func):
    return _BinReaderImpl().read(tape_fp, writer_func)
