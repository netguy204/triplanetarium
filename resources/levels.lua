local function last_is_one()
   return marker:evaluate() == 1
end

local levels = {
   {bstr = {'(s5)....'},
    dstr = '2+6-',
    win = last_is_one},
   {bstr = {' ___  .....',
            ' ___      .',
            '(s3).....9.',
            ' ___      .',
            ' ___  .....'},
    dstr = '3+3+9-2-5-3',
    win = last_is_one}
}

return levels
