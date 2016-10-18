(defvar *nodes* nil)

(defun createnode (title id desc type)
  (list :id id :title title :description desc :nodeType type))
(defun addnode (node) (push node *nodes*))

(defun dump-nodes ()
  (dolist (cd *nodes*)
    (format t "~{~a:~13t~a~%~}~%" cd)))

(defun save-graph (filename)
  (with-open-file (out filename
                   :direction :output
                   :if-exists :supersede)
    (with-standard-io-syntax
      (print *nodes* out))))

(defun load-graph (filename)
  (with-open-file (in filename)
    (with-standard-io-syntax
      (setf *nodes* (read in)))))

(defun select-by-title (title)
  (remove-if-not
   #'(lambda (node) (equal (getf node :title) title))
   *nodes*))

(defun select (selector-fn)
  (remove-if-not selector-fn *db*))


;;(defun artist-selector (artist)		
;;  #'(lambda (cd) (equal (getf cd :artist) artist)))

;;(defun where (&key title artist rating (ripped nil ripped-p))
;;  #'(lambda (cd)
 ;;     (and
  ;;     (if title    (equal (getf cd :title)  title)  t)
   ;;    (if artist   (equal (getf cd :artist) artist) t)
    ;;   (if rating   (equal (getf cd :rating) rating) t)
     ;;  (if ripped-p (equal (getf cd :ripped) ripped) t))))

;;(defun make-comparison-expr (field value)
;;  (list 'equal (list 'getf 'cd field) value))

(defun make-comparison-expr (field value)
  `(equal (getf cd ,field) ,value))

(defun make-comparisons-list (fields)
  (loop while fields
     collecting (make-comparison-expr (pop fields) (pop fields))))

(defmacro where (&rest clauses)
  `#'(lambda (cd) (and ,@(make-comparisons-list clauses))))
