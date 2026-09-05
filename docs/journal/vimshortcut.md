h - left 
l - right
j - down
k - up
x - remove unwanted charecter.

i - insert text. when we are in the insert mode i think we can use backspace , space and left right up down arrow keys too.

:q! - this is used to just exit the current terminal without saving the changes you have made in the file. and discarding all of the changes.

:wq - this command is used in vim to save file with all of changes you have made. and fun fact i am writing this file using neovim with the shortcut of nvim - and it is preconfigured with lazyvim. and i am now going to save this file with the command of :wq

                             Lesson 1.1 SUMMARY


  1. The cursor is moved using either the arrow keys or the hjkl keys.
         h (left)       j (down)       k (up)       l (right)

  2. To start Vim from the shell prompt type:  vim FILENAME <ENTER>

  3. To exit Vim type:     <ESC>   :q!   <ENTER>  to trash all changes.
             OR type:      <ESC>   :wq   <ENTER>  to save the changes.

  4. To delete the character at the cursor type:  x

  5. To insert or append text type:
         i   type inserted text   <ESC>         insert before the cursor
         A   type appended text   <ESC>         append after the line

NOTE: Pressing <ESC> will place you in Normal mode or will cancel
      an unwanted and partially completed command.

----------------------------------------------------------------------------------------------
So , here we go for our next Lesson. 
if we press "dw" in the normal mode then it will delete things. but the usecase of dw is a quite bit different . i have understood it but i cannot show it here right now. the proper phrrase it i cannot describe it with words now. but in future for sure i will try to write an article.

de - this is also used for delete things. only difference betweeen de and dw is with the use of dw we can delete the whitespace too till the next word start. but with de we will only delete the current word properly.
0 is used to get into the starting position of the line and $ is used to get the last position on the line. 
u - in the normal mode used for undo things , like we do with ctrl+z

just used some few motions. here are those. 
e - end of the current word
w- jumpt to the starting of next word.
$ - jump to the end of the line.

just learned some cool thing. 
as we know already that pressing e will take you into the end letter of the current word right? now if we press 2e then it will jump into the end of next word. like if we take a example of a sentence.
"Ram plays football in the field. and he is very happy" --> In this sentence if you are in the first letter of the first word of the sentence which is Ram and press e once then it will take you to the last letter of the word and that is m. but now if you press 2e then it will take you to the l of football. if you press 2e once more then it will take you to the e of 'the' and then you press just e and it will take you to the 'd' field. and the sentence ends here. and then you can press '0(zero)' and get back to the starting of the sentence. you can do the same fun by replacing the number form 2e to 3e to 4e. we can do same thing with 'w' and we can use 2w , 3w and so on fun.

                               Lesson 1.2 SUMMARY

  1. To delete from the cursor up to the next word type:        dw
  2. To delete from the cursor up to the end of the word type:  de
  3. To delete from the cursor to the end of a line type:       d$
  4. To delete a whole line type:                               dd

  5. To repeat a motion prepend it with a number:   2w
  6. The format for a change command is:
               operator   [number]   motion
     where:
       operator - is what to do, such as  d  for delete
       [number] - is an optional count to repeat the motion
       motion   - moves over the text to operate on, such as  w (word),
                  e (end of word),  $ (end of the line), etc.

  7. To move to the start of the line use a zero:  0

  8. To undo previous actions, type:           u  (lowercase u)
     To undo all the changes on a line, type:  U  (capital U)
     To undo the undos, type:                  CTRL-R

-----------------------------------------------------------------------------------------------------------
