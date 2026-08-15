
(in-package #:clith)


(defwith cl:make-broadcast-stream ((stream) body &rest streams)
  `(with-open-stream (,stream (make-broadcast-stream ,@streams))
     ,@body))

(defwith cl:make-concatenated-stream ((stream) body &rest input-streams)
  `(with-open-stream (,stream (make-concatenated-stream ,@input-streams))
     ,@body))

(defwith cl:make-echo-stream ((stream) body input-stream output-stream)
  `(with-open-stream (,stream (make-concatenated-stream ,input-stream ,output-stream))
     ,@body))

(defwith cl:make-string-input-stream ((stream) body string &optional start end)
  `(with-open-stream (,stream (make-string-input-stream ,string ,start ,end))
     ,@body))

(defwith cl:make-string-output-stream ((stream) body &key element-type)
  `(with-open-stream (,stream (make-string-output-stream :element-type ,element-type))
     ,@body))

(defwith cl:make-synonym-stream ((stream) body symbol)
  `(with-open-stream (,stream (make-synonym-stream ,symbol))
     ,@body))

(defwith cl:make-two-way-stream ((stream) body input-stream output-stream)
  `(with-open-stream (,stream (make-two-way-stream ,input-stream ,output-stream))
     ,@body))

(defwith cl:open ((stream) body filespec &rest options)
  `(with-open-file (,stream ,filespec ,@options)
     ,@body))

