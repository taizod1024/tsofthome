;;; -*- Mode: Lisp; Package: user -*-
;;;
;;; cobol-mode.l --- cobol-mode��ni-autoload�p���W���[��

;;; author
;;;     YAMAMOTO Taizo

;;; date
;;;     Last updated: "2003-04-29"

;;; description
;;;     cobol-mode��ni-autoload�p���W���[��

; �C�ӂ̎��_�Ŏ��s����̂�autoload�œǂݍ���
(export 'ed::cobol-mode "ed")
(autoload 'cobol-mode "cobol-mode" t)
(pushnew '("\\.cob$" . cobol-mode) *auto-mode-alist* :test 'equal)
(pushnew '("\\.cbl$" . cobol-mode) *auto-mode-alist* :test 'equal)
(pushnew '("\\.cobol$" . cobol-mode) *auto-mode-alist* :test 'equal)