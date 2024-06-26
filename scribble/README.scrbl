
(in-package #:adpgh)

@select-output-file["/README.md"]

@header{Common Lisp wITH}

Welcome to Clith!

This library defines the macro @fref[clith:with]. It allows you to create some objects, bind them to some variables, evaluate some expressions using these variables, and lastly the objects are destroyed automatically.

@mini-table-of-contents[]

@subheader{Installation}

@itemize[
@item{Manual:}
]
@code-block[:lang "sh"]{
cd ~/common-lisp
git clone https://github.com/Hectarea1996/clith.git
}
@itemize[
@item{Quicklisp (Ultralisp):}
]
@code-block[:lang "common-lisp"]{
(ql-dist:install-dist "http://dist.ultralisp.org/" :prompt nil)
(ql:quickload "clith")
}

@subheader{Documentation}

@itemize[
        @item{@href[:tag reference]}
]

@subheader{Basic usage}

The simplest way to use @fref[clith:with] is like using LET or MULTIPLE-VALUE-BIND:

@example{
(clith:with ((x 5)
             ((q r) (floor 45 32)))
  (+ x q r))
}


But also we can open a file that will be destroyed automatically when exiting the body of @fref[clith:with]:

@example{
(clith:with ((file (open-file "~/test.txt" :direction :output :if-does-not-exist :create :if-exists :supersede)))
  (print "Hey!" file))
}

And the content of the file should be @code{"Hey!"}.

Or we can even take the values of an object:

@example{
(defclass point ()
  ((x :initarg :x)
   (y :initarg :y)))

(clith:with ((start (make-instance 'point :x 5 :y 10))
             (end   (make-instance 'point :x -3 :y 21))
             ((x y)           (slots start))
             (((x2 x) (y2 y)) (slots end)))
  (+ (* x x2) (* y y2)))
}

@subheader{Customizing expansion}

When using certain binding form, we can control how @fref[clith:with] is expanded. In order to do this we must use @fref[clith:defwith].

As a simple example, let's define the with expander @code{specials}. It must bind some variables dynamically (via @code{(declare (special var))}).

First, take a look at the @fref[clith:defwith] macro:

@code-block{
(clith:defwith specials (vars (&rest vals) &body body)
  ...)
}

The macro @fref[clith:defwith] must receive 2 arguments: The variables used in the @fref[clith:with] binding and the body of the macro. Lastly, we receive the actual arguments of @code{specials}.

The rest of the definition is as follows:

@example|{
(clith:defwith specials (vars (&rest vals) &body body)
  `(multiple-value-bind ,vars (values ,@vals)
     (declare (special ,@vars))
     ,@body))
}|

It is like a regular macro. First we bind the variables, then we declare them as special and lastly we evaluate the body forms.

Let's use it:

@example{
(defun add-special-x-y ()
  (declare (special x y))
  (+ x y))

(clith:with (;; ...
             ((x y) (specials 5 10))
             ;; ...
             )
  ;; ...
  (add-special-x-y))
}

In this example, @code{(x y)} is bound to @code{vars} in @fref[clith:defwith], @code{((add-special-x-y))} to @code{body} and @code{(5 10)} to @code{vals}.

Let's see another example:

@example{
(clith:with (;; ...
             (z (specials 5 10))
             ;; ...
             )
  (print z))
}

Note that now we have @code{z} instead of @code{(z)}. Both cases are valid. CLITH makes sure that @code{vars} is always bound to a list of variables. If the user doesn't indicate any variable, then @code{NIL} is bound to @code{vars}.

@subheader{Built-in WITH expanders}

Every macro from the package @code{common-lisp} whose name starts with @code{with-} has its own expander. We've already seen an example using the expander of @code{with-open-file}. The complete list is:

@table[
@row[
@cell{CL Standard macro} @cell{WITH expander}
]
@row[
@cell{with-accesors} @cell{accesors}
]
@row[
@cell{with-compilation-unit} @cell{compilation-unit}
]
@row[
@cell{with-condition-restarts} @cell{condition-restarts}
]
@row[
@cell{with-hash-table-iterator} @cell{hash-table-iterator}
]
@row[
@cell{with-input-from-string} @cell{input-from-string}
]
@row[
@cell{with-open-file} @cell{open-file}
]
@row[
@cell{with-open-stream} @cell{open-stream}
]
@row[
@cell{with-output-to-string} @cell{output-to-string}
]
@row[
@cell{with-package-iterator} @cell{package-iterator}
]
@row[
@cell{with-simple-restart} @cell{simple-restart}
]
@row[
@cell{with-slots} @cell{slots}
]
@row[
@cell{with-standard-io-syntax} @cell{standard-io-syntax}
]
]
