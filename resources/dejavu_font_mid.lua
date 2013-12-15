
local function mid_font(scale)
   scale = scale or 1
   local characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.!?,\'"\\/+-*/%'
   local font = game:create_object('Font')
   font:load(game:atlas('resources/default'), 'mid', characters)
   font:scale(scale)
   font:line_separation(37)
    
   font:set_char_xadvance('a', 33)
   font:set_char_yadvance('a', 0)
   font:set_char_xlead('a', 3)
   font:set_char_ylead('a', -1)

   font:set_char_xadvance('b', 34)
   font:set_char_yadvance('b', 0)
   font:set_char_xlead('b', 5)
   font:set_char_ylead('b', -1)

   font:set_char_xadvance('c', 30)
   font:set_char_yadvance('c', 0)
   font:set_char_xlead('c', 3)
   font:set_char_ylead('c', -1)

   font:set_char_xadvance('d', 34)
   font:set_char_yadvance('d', 0)
   font:set_char_xlead('d', 3)
   font:set_char_ylead('d', -1)

   font:set_char_xadvance('e', 33)
   font:set_char_yadvance('e', 0)
   font:set_char_xlead('e', 3)
   font:set_char_ylead('e', -1)

   font:set_kerning('e', 'x', -1)

   font:set_char_xadvance('f', 19)
   font:set_char_yadvance('f', 0)
   font:set_char_xlead('f', 1)
   font:set_char_ylead('f', 0)

   font:set_kerning('f', 't', -1)

   font:set_kerning('f', 'w', -1)

   font:set_kerning('f', 'y', -1)

   font:set_kerning('f', '.', -4)

   font:set_kerning('f', '-', -3)

   font:set_char_xadvance('g', 34)
   font:set_char_yadvance('g', 0)
   font:set_char_xlead('g', 3)
   font:set_char_ylead('g', -11)

   font:set_char_xadvance('h', 34)
   font:set_char_yadvance('h', 0)
   font:set_char_xlead('h', 5)
   font:set_char_ylead('h', 0)

   font:set_char_xadvance('i', 15)
   font:set_char_yadvance('i', 0)
   font:set_char_xlead('i', 5)
   font:set_char_ylead('i', 0)

   font:set_char_xadvance('j', 15)
   font:set_char_yadvance('j', 0)
   font:set_char_xlead('j', -1)
   font:set_char_ylead('j', -11)

   font:set_char_xadvance('k', 31)
   font:set_char_yadvance('k', 0)
   font:set_char_xlead('k', 5)
   font:set_char_ylead('k', 0)

   font:set_kerning('k', 'a', -1)

   font:set_kerning('k', 'e', -2)

   font:set_kerning('k', 'o', -2)

   font:set_kerning('k', 'u', -2)

   font:set_kerning('k', 'y', -2)

   font:set_char_xadvance('l', 15)
   font:set_char_yadvance('l', 0)
   font:set_char_xlead('l', 5)
   font:set_char_ylead('l', 0)

   font:set_char_xadvance('m', 53)
   font:set_char_yadvance('m', 0)
   font:set_char_xlead('m', 5)
   font:set_char_ylead('m', 0)

   font:set_char_xadvance('n', 34)
   font:set_char_yadvance('n', 0)
   font:set_char_xlead('n', 5)
   font:set_char_ylead('n', 0)

   font:set_char_xadvance('o', 33)
   font:set_char_yadvance('o', 0)
   font:set_char_xlead('o', 3)
   font:set_char_ylead('o', -1)

   font:set_kerning('o', 'x', -2)

   font:set_kerning('o', '.', -1)

   font:set_kerning('o', '-', 1)

   font:set_char_xadvance('p', 34)
   font:set_char_yadvance('p', 0)
   font:set_char_xlead('p', 5)
   font:set_char_ylead('p', -11)

   font:set_char_xadvance('q', 34)
   font:set_char_yadvance('q', 0)
   font:set_char_xlead('q', 3)
   font:set_char_ylead('q', -11)

   font:set_char_xadvance('r', 22)
   font:set_char_yadvance('r', 0)
   font:set_char_xlead('r', 5)
   font:set_char_ylead('r', 0)

   font:set_kerning('r', 'c', -1)

   font:set_kerning('r', 'd', -1)

   font:set_kerning('r', 'e', -1)

   font:set_kerning('r', 'g', -1)

   font:set_kerning('r', 'h', -1)

   font:set_kerning('r', 'm', -1)

   font:set_kerning('r', 'n', -1)

   font:set_kerning('r', 'o', -1)

   font:set_kerning('r', 'q', -1)

   font:set_kerning('r', 'r', -1)

   font:set_kerning('r', 'x', -1)

   font:set_kerning('r', '.', -5)

   font:set_kerning('r', '-', -3)

   font:set_char_xadvance('s', 28)
   font:set_char_yadvance('s', 0)
   font:set_char_xlead('s', 3)
   font:set_char_ylead('s', -1)

   font:set_char_xadvance('t', 21)
   font:set_char_yadvance('t', 0)
   font:set_char_xlead('t', 1)
   font:set_char_ylead('t', 0)

   font:set_char_xadvance('u', 34)
   font:set_char_yadvance('u', 0)
   font:set_char_xlead('u', 5)
   font:set_char_ylead('u', -1)

   font:set_char_xadvance('v', 32)
   font:set_char_yadvance('v', 0)
   font:set_char_xlead('v', 2)
   font:set_char_ylead('v', 0)

   font:set_kerning('v', '.', -4)

   font:set_kerning('v', '-', -1)

   font:set_char_xadvance('w', 44)
   font:set_char_yadvance('w', 0)
   font:set_char_xlead('w', 2)
   font:set_char_ylead('w', 0)

   font:set_kerning('w', '.', -5)

   font:set_char_xadvance('x', 32)
   font:set_char_yadvance('x', 0)
   font:set_char_xlead('x', 2)
   font:set_char_ylead('x', 0)

   font:set_kerning('x', 'c', -1)

   font:set_kerning('x', 'e', -2)

   font:set_kerning('x', 'o', -2)

   font:set_char_xadvance('y', 32)
   font:set_char_yadvance('y', 0)
   font:set_char_xlead('y', 2)
   font:set_char_ylead('y', -11)

   font:set_kerning('y', '.', -8)

   font:set_kerning('y', '-', -1)

   font:set_char_xadvance('z', 28)
   font:set_char_yadvance('z', 0)
   font:set_char_xlead('z', 2)
   font:set_char_ylead('z', 0)

   font:set_char_xadvance('A', 37)
   font:set_char_yadvance('A', 0)
   font:set_char_xlead('A', 0)
   font:set_char_ylead('A', 0)

   font:set_kerning('A', 'c', -1)

   font:set_kerning('A', 'd', -1)

   font:set_kerning('A', 'e', -1)

   font:set_kerning('A', 'f', -2)

   font:set_kerning('A', 'o', -1)

   font:set_kerning('A', 'q', -1)

   font:set_kerning('A', 't', -1)

   font:set_kerning('A', 'v', -3)

   font:set_kerning('A', 'w', -2)

   font:set_kerning('A', 'y', -4)

   font:set_kerning('A', 'A', 2)

   font:set_kerning('A', 'C', -1)

   font:set_kerning('A', 'G', -1)

   font:set_kerning('A', 'O', -1)

   font:set_kerning('A', 'Q', -1)

   font:set_kerning('A', 'T', -4)

   font:set_kerning('A', 'V', -3)

   font:set_kerning('A', 'W', -3)

   font:set_kerning('A', 'Y', -4)

   font:set_kerning('A', '.', -1)

   font:set_kerning('A', '-', -1)

   font:set_char_xadvance('B', 37)
   font:set_char_yadvance('B', 0)
   font:set_char_xlead('B', 5)
   font:set_char_ylead('B', 0)

   font:set_kerning('B', 'C', -1)

   font:set_kerning('B', 'G', -1)

   font:set_kerning('B', 'O', -1)

   font:set_kerning('B', 'S', -1)

   font:set_kerning('B', 'V', -2)

   font:set_kerning('B', 'W', -2)

   font:set_kerning('B', 'Y', -3)

   font:set_char_xadvance('C', 38)
   font:set_char_yadvance('C', 0)
   font:set_char_xlead('C', 3)
   font:set_char_ylead('C', -1)

   font:set_kerning('C', 'Y', -1)

   font:set_char_xadvance('D', 42)
   font:set_char_yadvance('D', 0)
   font:set_char_xlead('D', 5)
   font:set_char_ylead('D', 0)

   font:set_kerning('D', 'A', -1)

   font:set_kerning('D', 'V', -1)

   font:set_kerning('D', 'Y', -3)

   font:set_char_xadvance('E', 34)
   font:set_char_yadvance('E', 0)
   font:set_char_xlead('E', 5)
   font:set_char_ylead('E', 0)

   font:set_char_xadvance('F', 31)
   font:set_char_yadvance('F', 0)
   font:set_char_xlead('F', 5)
   font:set_char_ylead('F', 0)

   font:set_kerning('F', 'a', -5)

   font:set_kerning('F', 'e', -3)

   font:set_kerning('F', 'i', -4)

   font:set_kerning('F', 'o', -2)

   font:set_kerning('F', 'r', -4)

   font:set_kerning('F', 'u', -3)

   font:set_kerning('F', 'y', -5)

   font:set_kerning('F', 'A', -5)

   font:set_kerning('F', 'S', -1)

   font:set_kerning('F', 'T', -1)

   font:set_kerning('F', '.', -9)

   font:set_char_xadvance('G', 42)
   font:set_char_yadvance('G', 0)
   font:set_char_xlead('G', 3)
   font:set_char_ylead('G', -1)

   font:set_kerning('G', 'T', -2)

   font:set_kerning('G', 'Y', -3)

   font:set_char_xadvance('H', 41)
   font:set_char_yadvance('H', 0)
   font:set_char_xlead('H', 5)
   font:set_char_ylead('H', 0)

   font:set_kerning('H', '.', -1)

   font:set_char_xadvance('I', 16)
   font:set_char_yadvance('I', 0)
   font:set_char_xlead('I', 5)
   font:set_char_ylead('I', 0)

   font:set_char_xadvance('J', 16)
   font:set_char_yadvance('J', 0)
   font:set_char_xlead('J', -3)
   font:set_char_ylead('J', -11)

   font:set_kerning('J', 'A', -1)

   font:set_kerning('J', '-', -2)

   font:set_char_xadvance('K', 35)
   font:set_char_yadvance('K', 0)
   font:set_char_xlead('K', 5)
   font:set_char_ylead('K', 0)

   font:set_kerning('K', 'a', -1)

   font:set_kerning('K', 'e', -3)

   font:set_kerning('K', 'o', -3)

   font:set_kerning('K', 'u', -3)

   font:set_kerning('K', 'y', -4)

   font:set_kerning('K', 'A', -1)

   font:set_kerning('K', 'C', -3)

   font:set_kerning('K', 'O', -3)

   font:set_kerning('K', 'T', -4)

   font:set_kerning('K', 'U', -1)

   font:set_kerning('K', 'W', -2)

   font:set_kerning('K', 'Y', -2)

   font:set_kerning('K', '-', -6)

   font:set_char_xadvance('L', 30)
   font:set_char_yadvance('L', 0)
   font:set_char_xlead('L', 5)
   font:set_char_ylead('L', 0)

   font:set_kerning('L', 'e', -1)

   font:set_kerning('L', 'o', -1)

   font:set_kerning('L', 'u', -1)

   font:set_kerning('L', 'y', -5)

   font:set_kerning('L', 'A', 1)

   font:set_kerning('L', 'O', -2)

   font:set_kerning('L', 'T', -7)

   font:set_kerning('L', 'U', -3)

   font:set_kerning('L', 'V', -6)

   font:set_kerning('L', 'W', -5)

   font:set_kerning('L', 'Y', -7)

   font:set_kerning('L', '-', -1)

   font:set_char_xadvance('M', 47)
   font:set_char_yadvance('M', 0)
   font:set_char_xlead('M', 5)
   font:set_char_ylead('M', 0)

   font:set_char_xadvance('N', 40)
   font:set_char_yadvance('N', 0)
   font:set_char_xlead('N', 5)
   font:set_char_ylead('N', 0)

   font:set_char_xadvance('O', 43)
   font:set_char_yadvance('O', 0)
   font:set_char_xlead('O', 3)
   font:set_char_ylead('O', -1)

   font:set_kerning('O', 'A', -1)

   font:set_kerning('O', 'V', -1)

   font:set_kerning('O', 'X', -3)

   font:set_kerning('O', 'Y', -3)

   font:set_kerning('O', '.', -2)

   font:set_kerning('O', '-', 2)

   font:set_char_xadvance('P', 33)
   font:set_char_yadvance('P', 0)
   font:set_char_xlead('P', 5)
   font:set_char_ylead('P', 0)

   font:set_kerning('P', 'a', -2)

   font:set_kerning('P', 'e', -2)

   font:set_kerning('P', 'i', -1)

   font:set_kerning('P', 'n', -1)

   font:set_kerning('P', 'o', -2)

   font:set_kerning('P', 'r', -1)

   font:set_kerning('P', 's', -1)

   font:set_kerning('P', 'u', -1)

   font:set_kerning('P', 'A', -3)

   font:set_kerning('P', 'Y', -1)

   font:set_kerning('P', '.', -8)

   font:set_kerning('P', '-', -1)

   font:set_char_xadvance('Q', 43)
   font:set_char_yadvance('Q', 0)
   font:set_char_xlead('Q', 3)
   font:set_char_ylead('Q', -7)

   font:set_kerning('Q', '-', 2)

   font:set_char_xadvance('R', 38)
   font:set_char_yadvance('R', 0)
   font:set_char_xlead('R', 5)
   font:set_char_ylead('R', 0)

   font:set_kerning('R', 'a', -1)

   font:set_kerning('R', 'e', -2)

   font:set_kerning('R', 'o', -2)

   font:set_kerning('R', 'u', -2)

   font:set_kerning('R', 'y', -3)

   font:set_kerning('R', 'A', -2)

   font:set_kerning('R', 'C', -3)

   font:set_kerning('R', 'T', -4)

   font:set_kerning('R', 'V', -3)

   font:set_kerning('R', 'W', -2)

   font:set_kerning('R', 'Y', -3)

   font:set_kerning('R', '.', -2)

   font:set_kerning('R', '-', -2)

   font:set_char_xadvance('S', 34)
   font:set_char_yadvance('S', 0)
   font:set_char_xlead('S', 4)
   font:set_char_ylead('S', -1)

   font:set_kerning('S', 'A', 1)

   font:set_char_xadvance('T', 33)
   font:set_char_yadvance('T', 0)
   font:set_char_xlead('T', 0)
   font:set_char_ylead('T', 0)

   font:set_kerning('T', 'a', -9)

   font:set_kerning('T', 'c', -9)

   font:set_kerning('T', 'e', -9)

   font:set_kerning('T', 'i', -2)

   font:set_kerning('T', 'o', -9)

   font:set_kerning('T', 'r', -8)

   font:set_kerning('T', 's', -9)

   font:set_kerning('T', 'u', -8)

   font:set_kerning('T', 'w', -9)

   font:set_kerning('T', 'y', -8)

   font:set_kerning('T', 'A', -4)

   font:set_kerning('T', 'C', -3)

   font:set_kerning('T', 'T', -1)

   font:set_kerning('T', '.', -6)

   font:set_kerning('T', '-', -5)

   font:set_char_xadvance('U', 40)
   font:set_char_yadvance('U', 0)
   font:set_char_xlead('U', 5)
   font:set_char_ylead('U', -1)

   font:set_kerning('U', 'Z', -1)

   font:set_char_xadvance('V', 37)
   font:set_char_yadvance('V', 0)
   font:set_char_xlead('V', 0)
   font:set_char_ylead('V', 0)

   font:set_kerning('V', 'a', -4)

   font:set_kerning('V', 'e', -4)

   font:set_kerning('V', 'i', -1)

   font:set_kerning('V', 'o', -4)

   font:set_kerning('V', 'u', -4)

   font:set_kerning('V', 'y', -1)

   font:set_kerning('V', 'A', -3)

   font:set_kerning('V', 'O', -1)

   font:set_kerning('V', '.', -7)

   font:set_kerning('V', '-', -3)

   font:set_char_xadvance('W', 53)
   font:set_char_yadvance('W', 0)
   font:set_char_xlead('W', 2)
   font:set_char_ylead('W', 0)

   font:set_kerning('W', 'a', -3)

   font:set_kerning('W', 'e', -3)

   font:set_kerning('W', 'i', -1)

   font:set_kerning('W', 'o', -3)

   font:set_kerning('W', 'r', -2)

   font:set_kerning('W', 'u', -2)

   font:set_kerning('W', 'y', -1)

   font:set_kerning('W', 'A', -3)

   font:set_kerning('W', '.', -6)

   font:set_kerning('W', '-', -2)

   font:set_char_xadvance('X', 38)
   font:set_char_yadvance('X', 0)
   font:set_char_xlead('X', 2)
   font:set_char_ylead('X', 0)

   font:set_kerning('X', 'e', -2)

   font:set_kerning('X', 'C', -4)

   font:set_kerning('X', 'O', -3)

   font:set_kerning('X', 'T', -1)

   font:set_kerning('X', '-', -3)

   font:set_char_xadvance('Y', 33)
   font:set_char_yadvance('Y', 0)
   font:set_char_xlead('Y', 0)
   font:set_char_ylead('Y', 0)

   font:set_kerning('Y', 'a', -7)

   font:set_kerning('Y', 'e', -7)

   font:set_kerning('Y', 'i', -2)

   font:set_kerning('Y', 'o', -7)

   font:set_kerning('Y', 'u', -6)

   font:set_kerning('Y', 'A', -4)

   font:set_kerning('Y', 'C', -3)

   font:set_kerning('Y', 'O', -3)

   font:set_kerning('Y', '.', -11)

   font:set_kerning('Y', '-', -6)

   font:set_char_xadvance('Z', 37)
   font:set_char_yadvance('Z', 0)
   font:set_char_xlead('Z', 2)
   font:set_char_ylead('Z', 0)

   font:set_kerning('Z', '-', -1)

   font:set_char_xadvance('0', 34)
   font:set_char_yadvance('0', 0)
   font:set_char_xlead('0', 4)
   font:set_char_ylead('0', -1)

   font:set_char_xadvance('1', 34)
   font:set_char_yadvance('1', 0)
   font:set_char_xlead('1', 6)
   font:set_char_ylead('1', 0)

   font:set_char_xadvance('2', 34)
   font:set_char_yadvance('2', 0)
   font:set_char_xlead('2', 4)
   font:set_char_ylead('2', 0)

   font:set_char_xadvance('3', 34)
   font:set_char_yadvance('3', 0)
   font:set_char_xlead('3', 4)
   font:set_char_ylead('3', -1)

   font:set_char_xadvance('4', 34)
   font:set_char_yadvance('4', 0)
   font:set_char_xlead('4', 3)
   font:set_char_ylead('4', 0)

   font:set_char_xadvance('5', 34)
   font:set_char_yadvance('5', 0)
   font:set_char_xlead('5', 4)
   font:set_char_ylead('5', -1)

   font:set_char_xadvance('6', 34)
   font:set_char_yadvance('6', 0)
   font:set_char_xlead('6', 4)
   font:set_char_ylead('6', -1)

   font:set_char_xadvance('7', 34)
   font:set_char_yadvance('7', 0)
   font:set_char_xlead('7', 4)
   font:set_char_ylead('7', 0)

   font:set_char_xadvance('8', 34)
   font:set_char_yadvance('8', 0)
   font:set_char_xlead('8', 4)
   font:set_char_ylead('8', -1)

   font:set_char_xadvance('9', 34)
   font:set_char_yadvance('9', 0)
   font:set_char_xlead('9', 4)
   font:set_char_ylead('9', -1)

   font:set_char_xadvance('.', 17)
   font:set_char_yadvance('.', 0)
   font:set_char_xlead('.', 6)
   font:set_char_ylead('.', 0)

   font:set_char_xadvance('!', 22)
   font:set_char_yadvance('!', 0)
   font:set_char_xlead('!', 8)
   font:set_char_ylead('!', 0)

   font:set_char_xadvance('?', 29)
   font:set_char_yadvance('?', 0)
   font:set_char_xlead('?', 4)
   font:set_char_ylead('?', 0)

   font:set_char_xadvance(',', 17)
   font:set_char_yadvance(',', 0)
   font:set_char_xlead(',', 4)
   font:set_char_ylead(',', -6)

   font:set_char_xadvance("'", 15)
   font:set_char_yadvance("'", 0)
   font:set_char_xlead("'", 5)
   font:set_char_ylead("'", 24)

   font:set_char_xadvance('"', 25)
   font:set_char_yadvance('"', 0)
   font:set_char_xlead('"', 5)
   font:set_char_ylead('"', 24)

   font:set_char_xadvance('\\', 18)
   font:set_char_yadvance('\\', 0)
   font:set_char_xlead('\\', 0)
   font:set_char_ylead('\\', -5)

   font:set_char_xadvance('/', 18)
   font:set_char_yadvance('/', 0)
   font:set_char_xlead('/', 0)
   font:set_char_ylead('/', -5)

   font:set_char_xadvance('+', 45)
   font:set_char_yadvance('+', 0)
   font:set_char_xlead('+', 6)
   font:set_char_ylead('+', 0)

   font:set_char_xadvance('-', 19)
   font:set_char_yadvance('-', 0)
   font:set_char_xlead('-', 3)
   font:set_char_ylead('-', 13)

   font:set_kerning('-', 'o', 1)

   font:set_kerning('-', 'v', -1)

   font:set_kerning('-', 'y', -1)

   font:set_kerning('-', 'A', -1)

   font:set_kerning('-', 'B', -2)

   font:set_kerning('-', 'G', 2)

   font:set_kerning('-', 'J', 3)

   font:set_kerning('-', 'O', 2)

   font:set_kerning('-', 'Q', 2)

   font:set_kerning('-', 'T', -5)

   font:set_kerning('-', 'V', -3)

   font:set_kerning('-', 'W', -2)

   font:set_kerning('-', 'X', -3)

   font:set_kerning('-', 'Y', -6)

   font:set_char_xadvance('*', 27)
   font:set_char_yadvance('*', 0)
   font:set_char_xlead('*', 2)
   font:set_char_ylead('*', 16)

   font:set_char_xadvance('/', 18)
   font:set_char_yadvance('/', 0)
   font:set_char_xlead('/', 0)
   font:set_char_ylead('/', -5)

   font:set_char_xadvance('%', 51)
   font:set_char_yadvance('%', 0)
   font:set_char_xlead('%', 3)
   font:set_char_ylead('%', -1)

   return font
end

return mid_font
