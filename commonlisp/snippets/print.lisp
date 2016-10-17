(defun printTriangle (n)
  (loop
     for i from 1 to n
     do
       (loop for j from 1 to (- n i)
	    do (format t "-"))
       (loop for j from 1 to (- (* 2 i) 1)
	  do (prin1 '*))
              (loop for j from 1 to (- n i)
	    do (format t "-"))
       (format t "~%")))
(printTriangle 23)
