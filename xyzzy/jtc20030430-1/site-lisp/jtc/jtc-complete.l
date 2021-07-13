;;; -*- Mode: Lisp; Package:jtc -*-
;;;
;;; jtc-complete.l --- JavaTinyConsole
;;;

;;; author
;;;	YAMAMOTO Taizo

;;; date
;;;	Last updated: "2003-05-02"

(provide "jtc/jtc-complete")

(require "java")
(eval-when (:compile-toplevel :load-toplevel :execute)
  (require "jtc/jtc-def"))

(in-package "jtc")

(export '(jtc-do-completion
	  jtc-info
	  jtc-insert-open-paren
	  jtc-insert-close-paren
	  jtc-update-temp-completion-list
	  *jtc-completion-file-list*
	  *jtc-info-url-hook*
	  *jtc-info-hook*
	  *jtc-temp-completion-file*))

(defvar *jtc-completion-file-list*
  ; �⊮�t�@�C���̃��X�g�i���C���h�J�[�h�j
  ; ���̂܂܂��ƋN�����Ɏ����I�Ɉꎞ�⊮���X�g�̑O��̌��ʂ�ǂݍ���ł����B
  (list (merge-pathnames "site-lisp/jtc/complete/*.lst" (si:system-root))))

(defvar *jtc-doclet* "ListClass")
(defvar *jtc-docletpath* (merge-pathnames "site-lisp/jtc/doclet" (si:system-root)))
(defvar *jtc-temp-completion-file* (merge-pathnames "site-lisp/jtc/complete/temp.lst" (si:system-root)))
(defvar *jtc-complete-initialized* nil)

(define-key ed::*java-mode-map* #\( 'jtc-insert-open-paren)
(define-key ed::*java-mode-map* #\) 'jtc-insert-close-paren)
(define-key ed::*java-mode-map* #\] 'jtc-insert-close-paren)
(define-key ed::*java-mode-map* #\. 'jtc-insert-close-paren)
(define-key ed::*java-mode-map* #\# 'jtc-insert-close-paren)
(define-key ed::*java-mode-map* #\TAB 'jtc-do-completion)
(set-syntax-punctuation ed::*java-mode-syntax-table* #\#)
(define-key ed::*java-mode-map* #\F1 'jtc-info)

(defvar *jtc-class-list* nil)		; �N���X�̈ꗗ���X�g
(defvar *jtc-member-list-hash* nil)	; �e�N���X���̃����o�̃��X�g���i�[����n�b�V��
(defvar *jtc-superclass-hash* nil)	; �e�N���X���̃X�[�p�[�N���X���i�[����n�b�V��
(defvar *jtc-jcinfo-hash* nil)		; �N���X�E�����o���L�[�Ƃ���jcinfo���i�[����n�b�V��
; ���Y�p�F
; *jtc-jcinfo-hash*/*jtc-member-list-hash* ���n�b�V���i�����o�j���i�[����n�b�V���i�N���X�j�ɂ��Ȃ������̂�
; �R���X�g���N�^��⊮���X�g�����X�폜����K�v�����������ߎ~�߂��B�n�b�V���̃n�b�V���̓J�b�R��������
; �����̗�O������̂Œ��߂��B

(defvar *jtc-keyword-list*
  '("null" "true" "false" "class"
    "interface" "extends" "implements"
    "instanceof" "import" "package" "public"
    "protected" "private" "final" "static"
    "abstract" "native" "synchronized" "volatile"
    "transient" "for" "while" "do"
    "if" "else" "switch" "case"
    "default" "break" "continue" "return"
    "try" "catch" "finally" "throw"
    "throws" "const" "goto" "byte"
    "char" "short" "int" "long"
    "float" "double" "boolean" "void"
    "new"		; �� narrow-to-term1/parse-term1�ł͌ʂɃ`�F�b�N���f�ʂ�����
    "this" "super"	; �� reduce-term1�̒��ŃI�u�W�F�N�g�Ƃ��Ďg�p����̂Ń`�F�b�N���Ȃ�
    ))

(defstruct jcinfo
  (kind "")
  (return "")
  (truename "")
  (name "")
  (signature "")
  (url ""))

;;; --------------------------------
;;; ���̕\���p�t�b�N
;;; �����ł�browser.dll���g�킹�Ē���
;;; www-mode�Ƃ��O����IE���Ă̂��ܘ_����
;;; Sun, 07 Oct 2001 12:27:56 +0900
(defvar *jtc-info-url-hook*
  #'(lambda (i)
      (let ((p (car *jtc-jdk-document-directory*)))
	(concat ; "http://"�łȂ���΃��[�J���Ȃ̂ŁA"file://"��ǉ�
		(unless (string-match "^http://" p) "file://")
		; �w�肳�ꂽ�p�X
		p
		; "/"�ŏI����ĂȂ����"/"��ǉ�
		(unless (string-match "/$" p) "/")
		; �f�B���N�g����ݒ�
		"api/"
		; �⊮���X�g���璲�B
		(jcinfo-url i)))))

(defvar *jtc-info-hook*
  #'(lambda (u)
      (let (navigate)
	(setq navigate
	      (or (and (find-package "browserex")
		       (find-symbol "navigate" "browserex"))
		  (find-symbol "navigate" "user")))
	(when navigate
	  (funcall navigate u)
	  (message u)))))

;;; --------------------------------
;;; ���̕\��
;;; Sun, 07 Oct 2001 12:27:56 +0900
(defun jtc-info ()
  (interactive)
  ; �ςȃV���^�b�N�X�Ȃ�I��
  (when (parse-point-syntax (point))
    (return-from jtc-info nil))
  ; �������`�F�b�N
  ; ���Ԃ��|����̂ŁA�\�Ȍ���load-completion-file�̌Ăяo����x�点��B
  ; �Ώۂ͈ȉ��̂Ƃ���B
  ; - jtc-do-completion
  ; - jtc-info
  ; - jtc-insert-open-paren
  ; - jtc-insert-close-paren
  ; - jtc-update-temp-completion-list
  (unless *jtc-complete-initialized*
    (load-completion-file)
    (setq *jtc-complete-initialized* t))
  ; ���낢�낷��
  (let (q r s u v w)
    (save-excursion
      (skip-syntax-spec-backward "w_")
      (setq q (point))
      (when (setq r (find (preceding-char) '(#\. #\#) :test 'char=))
	(setq s (reduce-term (parse-term))))
      (setq u (buffer-substring q (save-excursion (skip-syntax-spec-forward "w_") (point)))))
    (cond ; �N���X���Ƃ����邩�H����Ȃ�A������l�����Ďg�p
	  (s (cond ; (1)�����o�������邩�H�Ȃ��Ȃ�N���X�������g�p
		   ((string-equal u "")
		    (if (setq w (get-jcinfo-class s))
			(popup-string (jcinfo-signature w) (point))
		      (popup-string (format nil "~A ???" s) (point))))
		   ; (2)�m���Ă�N���X���Ń����o�����L��悤��
		   ((setq w (get-jcinfo-member s u))
		    (popup-string (jcinfo-signature w) (point)))
		   ; (3)�m��Ȃ��N���X��������A�����o���Ȃ񂼒m��Ȃ�
		   ((popup-string (format nil "identifier ???") (point)))))
	  ; �P�ƂŌ���Ă���悤��
	  (t (cond ; (4)�ϐ����E�����o�����N���X���ɕϊ��ł���H
		   ((setq v (reduce-term (list u)))
		    (setq w (get-jcinfo-class v))
		    (popup-string (jcinfo-signature w) (point)))
		   ; (5)�ϐ����E�����o���ł��Ȃ����A�m���Ă�N���X���ł��Ȃ��悤��
		   ((string-equal u "")
		    (popup-string (format nil "where ???") (point)))
		   (t
		    (popup-string (format nil "class name ???\nidentifier ???" u) (point))))))
    ; �t�b�N�̌Ăяo��
    (let (u)
      (and w
	   *jtc-show-api-ref*
	   *jtc-info-url-hook*
	   (setq u (funcall *jtc-info-url-hook* w))
	   *jtc-info-hook*
	   (funcall *jtc-info-hook* u)))))

;;; --------------------------------
;;; �J�����ʂ̏ꍇ
;;; Sun, 07 Oct 2001 12:28:24 +0900
(defun jtc-insert-open-paren (&optional (arg 1))
  (interactive "*p")
  ; �������`�F�b�N
  (unless *jtc-complete-initialized*
    (load-completion-file)
    (setq *jtc-complete-initialized* t))
  ; �J������
  (let (p q)
    (multiple-value-bind (p q)
	(reduce-term (parse-term))
      (c-electric-insert arg)
      (when q
	(cond ((string-match "[f]" (jcinfo-kind q))
	       (popup-string "field name ???" (point)))
	      (t
	       (popup-string (jcinfo-signature q) (point))))))))

;;; --------------------------------
;;; �����ʂ̏ꍇ
;;; Sun, 07 Oct 2001 12:28:36 +0900
(defun jtc-insert-close-paren (&optional (arg 1))
  (interactive "*p")
  ; �������`�F�b�N
  (unless *jtc-complete-initialized*
    (load-completion-file)
    (setq *jtc-complete-initialized* t))
  ; ������
  (let (p q r)
    (self-insert-command arg)
    (multiple-value-bind (p q)
	(reduce-term (parse-term))
      (when p
	(cond ((setq r (get-jcinfo-class p))
	       (popup-string (jcinfo-signature r) (point)))
	      ((eq *last-command-char* #\.)
	       (popup-string (format nil "~A ???" p) (point)))
	      (t
	       (popup-string (format nil "~A" p) (point))))))))

;;; --------------------------------
;;; �⊮����
;;; Sat, 06 Jan 2001 07:55:44 +0900
(defun jtc-do-completion ()
  (interactive "*")
  ; �s���̏ꍇ�̃C���f���g
  (when (save-excursion
	  (skip-chars-backward " \t")
	  (bolp))
    (c-indent-line)
    (return-from jtc-do-completion t))
  ; �⊮�����Ȃ�I��
  (unless *jtc-member-completion*
    (return-from jtc-do-completion nil))
  ; �ςȃV���^�b�N�X�Ȃ�I��
  (when (parse-point-syntax (point))
    (message "cannot do completion in string")
    (return-from jtc-do-completion nil))
  ; �������`�F�b�N
  (unless *jtc-complete-initialized*
    (load-completion-file)
    (setq *jtc-complete-initialized* t))
  ; �⊮����
  (let (p q r s u v w)
    (setq p (point))
    (save-excursion
      (skip-syntax-spec-backward "w_")
      (setq q (point))
      (setq r (find (preceding-char) '(#\. #\#) :test 'char=))
      (setq s (reduce-term (parse-term))))
    (cond (r (setq u (do-completion q p :list (gethash s *jtc-member-list-hash*) nil nil t))
	     (setq v (buffer-substring q (point)))
	     (setq z (get-jcinfo-member s v))
	     (if (and z (eq u t)) (popup-string (jcinfo-signature z) (point))))
	  (t (do-completion q p :list (append *jtc-keyword-list* *jtc-class-list*) nil nil t)))))

;;; --------------------------------
;;; �ꎞ�I�⊮���X�g�쐬
(defun jtc-update-temp-completion-list ()
  (interactive)
  ; �������`�F�b�N
  (unless *jtc-complete-initialized*
    (load-completion-file)
    (setq *jtc-complete-initialized* t))
  ; �⊮���X�g�쐬
  (save-window-excursion
    (let ((cmd (format nil "~A -doclet ~A -docletpath \"~A\" *.java > \"~A\""
		       (car *jtc-javadoc-history*)
		       *jtc-doclet*
		       *jtc-docletpath*
		       *jtc-temp-completion-file*))
	  (dir (default-directory)))
      (long-operation
	(with-output-to-temp-buffer (*jtc-command-buffer-name*)
	  (format t "�Ώ��ިڸ��\n\t~A\n�ꎞ�⊮ؽč쐬�� ...\n\t~A" dir cmd))
	(message "�ꎞ�⊮ؽč쐬�� ...")
	(execute-shell-command cmd t *jtc-output-buffer-name* t dir))
      (if (load-completion-file1 *jtc-temp-completion-file*)
	  (show-message "�ꎞ�⊮ؽĂ̍X�V���������܂����B")
	(show-message "�ꎞ�⊮ؽĂ̍쐬�Ɏ��s���܂����B")))))

;;; --------------------------------
;;; ���̎擾
;;; Sat, 06 Oct 2001 23:37:57 +0900
(defun get-jcinfo-member (x y)
  (let (z)
    (setq z (gethash (list x y) *jtc-jcinfo-hash*))
    (while (and x (not z))
      (setq x (gethash x *jtc-superclass-hash*))
      (setq z (gethash (list x y) *jtc-jcinfo-hash*)))
    z))

(defun get-jcinfo-class (x)
  (gethash (list x) *jtc-jcinfo-hash*))

;;; --------------------------------
;;; ��͔͈͂̓���
;;; ���ƂĂ��Ȃ���������
;;; �@parse-term1�Ƃ͈Ⴂ���g�܂Ō@�艺����K�v���Ȃ��̂ŁA���[�v�őO�i����
;;; �@�������Aif/while/catch�Ȃǂ̃L�[���[�h���o�ė�����A�����Ⴂ�̏ꏊ�Ȃ̂ŏI������
;;; Sat, 06 Jan 2001 07:55:44 +0900
(defun narrow-to-term1 ()
  ; �����Ȃ�R�����g�╶����̒��Ȃ�I��
  (if (find (parse-point-syntax (point)) '(:string :comment))
      (return-from narrow-to-term1 nil))
  ; ����ʂ��������Ĕ͈͂�I��
  (let ((p (point)))
    (loop
      ; ��芸�����󔒂��X�L�b�v
      (skip-chars-backward " \t\n")
      (cond
       ; �����o���Z�q�炵���̂ŃX�L�b�v
       ; �������o���Z�q�����͑����ďo�������玸�s
       ((find (preceding-char) '(#\. #\#) :test 'char=)
	(backward-char)
	(skip-chars-backward " \t\n")
	(if (find (preceding-char) '(#\. #\#) :test 'char=)
	    (return-from narrow-to-term1 nil)))
       ; �V���^�b�N�X���قȂ�ꍇ�ɂ͂����Œ��f
       ; �����̏����Ƀ}�b�`����̂͂Q��ڈȍ~
       ; ����قǕςȏ����������Ȃ��ƈ����|��Ȃ�
       ((find (parse-point-syntax (point)) '(:string :comment))
	(skip-chars-backward " \t\n")
	(narrow-to-region (point) p)
	(return-from narrow-to-term1 t))
       ; ������Ȃ�΂����Œ��f
       ((and (syntax-string-p (preceding-char))
	     (eq (parse-point-syntax (1- (point))) :string))
	(while (and (scan-buffer "\"" :reverse t :no-dup t)
		    (parse-point-syntax (point))))
	(narrow-to-region (point) p)
	(return t))
       ; ���ʂ̃X�L�b�v
       ; ���}�b�`���銇�ʂ��Ȃ���Ύ��s
       ((save-excursion
	  (backward-char)
	  (looking-at "[\]\)]"))
	(backward-char)
	(unless (goto-matched-parenthesis)
	  (goto-char p)
	  (return-from narrow-to-term1 nil)))
       ; new ���Z�q�̃X�L�b�v
       ; �L�[���[�h�̒��� new ���Z�q�̓X�L�b�v����
       ((looking-back "new")
	(goto-char (- (point) 3)))
       ; ���ʎq�̃X�L�b�v
       ; ��if/while/catch�Ȃǂ����ꂽ�炱���Œׂ�
       ((save-excursion
	  (and (skip-syntax-spec-backward "w_")
	       (not (looking-at "[0-9]"))))
	(let ((q (point))
	      (r nil))
	  (skip-syntax-spec-backward "w_")
	  (setq r (buffer-substring q (point)))
	  (if (and (find r *jtc-keyword-list* :test 'string=)
		   (not (find r '("this" "super") :test 'string=)))
	      (return-from narrow-to-term1 nil))))
       ; ����������΂��̂܂܏I��낤
       (t
	; �P��ڂɂǂ��ɂ��Y�����Ȃ���Ύ��s
	(when (eq (point) p)
	  (return-from narrow-to-term1 nil))
	(return t))))
    ; �󔒂��X�L�b�v�����������ɖ߂�
    (skip-chars-forward " \t\n")
    ; �L���X�g���O��
    ; ���L���X�g�̓����o���Z�q�����D��x���Ⴂ����
    (if (looking-at "\\(([ \t\n]*[a-zA-Z_\\$][$0-9a-zA-Z_\\]*[ \t\n]*)[ \t\n]*\\)[^ \t\n\.\#]")
	(goto-char (match-end 1)))
    (narrow-to-region (point) p)))

;;; --------------------------------
;;; �͈͌���{�͈͉��
;;; ���ƂĂ��Ȃ���������
;;; �@narrow-to-term1�őI�����ꂽ�͈͂��ő���D�ӓI�ɉ��߂���
;;; Sat, 06 Jan 2001 07:55:44 +0900
(defun parse-term ()
  (interactive)
  (save-excursion
    (save-restriction
      (when (narrow-to-term1)
	(parse-term1)))))

(defun parse-term1 ()
  ; �󔒂��΂�
  (skip-chars-forward " \t\n")
  ; new ���Z�q���΂�
  (when (looking-at "new[ \t\n]+")
    (goto-char (match-end 0)))
  (let (p s)
    (cond
     ; ������̏ꍇ
     ((and (syntax-string-p (following-char))
	   (eq (parse-point-syntax (1+ (point))) :string))
      (while (and (scan-buffer "\"" :no-dup t)
		  (parse-point-syntax (1+ (point)))))
      (goto-char (match-end 0))
      (setq s (list "String")))
     ; ���ʎq
     ((looking-at "\\([a-zA-Z_\\$][$0-9a-zA-Z_\\]*\\)[ \t\n]*")
      (goto-char (match-end 0))
      (setq s (list (match-string 1)))
      (when (looking-at "[\(\[]")
	(goto-matched-parenthesis)
	(forward-char)))
     ; ���ʕt���i�����L���X�g�j
     ((char= (following-char) #\()
      (prog1
	  (save-excursion
	    (save-restriction
	      (setq p (save-excursion (goto-matched-parenthesis) (point)))
	      (forward-char)
	      (narrow-to-region (point) p)
	      (setq s (parse-term1))))
	(goto-char p)
	(forward-char)))
     (t
      nil))
    ; �����o�Ƃ���������p�����ĉ��
    ; �����̏����ł́As���L���X�g�̏ꍇ��s������Ԃ��B
    ; �������o�̏ꍇ�ɂ́A�p�����ĉ�͂���B
    (append s
	    (when (looking-at "[ \t\n]*[\.#]")
	      (goto-char (match-end 0))
	      (parse-term1)))))

;;; --------------------------------
;;; �V�[�P���X�̃��_�N�V����
;;; ���߂�l�͌^�Ƃ��̌��ɂȂ郁���o�̍\���̂�Ԃ�
;;; ����{�I�Ƀ����o�̎擾��ړI�Ƃ��Ă���
;;; ���N���X���̂��̂̏���get-jcinfo-class�𒼐ڌĂԂ���
;;; Sat, 06 Jan 2001 07:55:44 +0900
(defun reduce-term (arg1)
  (if (find (car arg1) '("this" "super") :test 'string=) (pop arg1))
  (if (find (car arg1) *jtc-class-list* :test 'string=)
      (reduce-term1 arg1)
    (let ((q (scan-var (pop arg1))))
      (if q (reduce-term1 (cons q arg1))))))

(defun reduce-term1 (arg1 &optional arg2)
  (cond
   ; ���X�����̂Ȃ牽�ɂ��Ԃ��Ȃ�
   ((null arg1)
    (values nil nil))
   ; �v�f����̏ꍇ�A�����o�̗v�f���Ԃ�
   ((eq (length arg1) 1)
    (let ((p (pop arg1)))
      (values p (or arg2 (gethash (list p p) *jtc-jcinfo-hash*)))))
   ; �v�f����ȏ�L��Ȃ�΃��X�g��Z������
   (t
    ; �����o��������΃X�[�p�[�N���X�����������
    (let ((z (get-jcinfo-member (pop arg1) (pop arg1))))
      (if z (reduce-term1 (cons (jcinfo-return z) arg1) z))))))

;;; --------------------------------
;;; ���[�J���Q�Ɓ{�t�B�[���h���̑���
;;; Sat, 06 Jan 2001 07:55:44 +0900
(defun scan-var (s)
  (unless (stringp s)
    (return-from scan-var nil))
  (save-excursion
    (save-restriction
      (narrow-to-region (point-min) (point)) ; �\�[�X��r���ɑ}������ꍇ�̂��߂ɔO�ׁ̈Anarrow-to-region���Ƃ�
      (let ((p nil))
	(while (scan-buffer "\\({\\)\\|\\(}\\)\\|\\()\\)\\|\\(\\<\\([$a-zA-Z0-9_.]+\\)\\([ \t\n]*\\[[^\]]*\\][ \t\n]*\\|[ \t\n]+\\)\\(\\w+\\)\\)" :regexp t :reverse t :no-dup t)
	  (cond
	   ; �V���^�b�N�X�����r���[�Ȃ�X�L�b�v
	   ((parse-point-syntax (point)))
	   ; �J�������ʂ̏ꍇ�͈��ɑJ�ځi�ȍ~�͈����������Ώہj
	   ((match-string 1)
	    (setq p t))
	   ; ���钆���ʂ͕K���X�L�b�v
	   ((match-string 2)
	    (goto-matched-parenthesis))
	   ; ���鏬���ʂ͍ŏ��̓X�L�b�v�i�J�������ʈȍ~�͑Ώہj
	   ((match-string 3)
	    (if p
		(setq p nil)
	      (goto-matched-parenthesis)))
	   ; �L�[���[�h�Ɋ܂܂�Ȃ���΁A�����N���X
	   ((not (find (match-string 5) *jtc-keyword-list* :test 'string=))
	    (let ((q (match-string 5)))
	      ; �Ƃ肠���������������̂���v���邩�H
	      (if (string= s (match-string 7))
		  (return-from scan-var q))
	      ; �ꏏ�Ɍ����������̂���v���邩�H
	      (save-excursion
		(while (scan-buffer "\\(;\\)\\|,[ \t\n]*\\(\\w+\\)" :regexp t :reverse nil :no-dup nil :tail t)
		  (cond
		   ; �V���^�b�N�X�����r���[�Ȃ�X�L�b�v
		   ((parse-point-syntax (point)))
		   ; �Z�~�R�������������炱�̐錾�͔�����
		   ((match-string 1)
		    (return nil))
		   ; ���Ɍ����������̂���v���邩�H
		   ((string= s (match-string 2))
		    (return-from scan-var q)))))))))))))

;;; --------------------------------
;;; �⊮�t�@�C���̓ǂݍ���
;;; Sat, 06 Jan 2001 07:55:44 +0900
(defun load-completion-file ()
  ; ������
  (setq *jtc-member-list-hash* (make-hash-table :test #'equal))
  (setq *jtc-jcinfo-hash* (make-hash-table :test #'equal))
  (setq *jtc-superclass-hash* (make-hash-table :test #'equal))
  ; �ǂݍ���
  (long-operation
    (dolist (item *jtc-completion-file-list*)
      (mapcar 'load-completion-file1
	      (sort (directory item :absolute t) #'string-lessp)))))

(defun load-completion-file1 (arg1)
  ; �⊮�t�@�C���̓ǂݍ���
  (set-buffer (ed::find-file-internal arg1))
  (message "�⊮ؽēǍ��� ... ~A" arg1)
  (goto-char (point-min))
  (unless (scan-buffer "")
    (kill-buffer (ed::find-file-internal arg1))
    (return-from load-completion-file1 nil))
  ; �N���X�P�ʂŃ��[�v
  (while (looking-at "\\([^\n]*\\)\n\\([^\n]*\\)\n\\([^\n]*\\)\n\\([^\n]*\\)\n\\([^\n]*\\)\n")
    (goto-char (match-end 0))
    (let* ((p (match-string 1))
	   (q (if (< 0 (length (match-string 3)))
		  (match-string 3)))
	   (r (gethash q *jtc-member-list-hash*))
	   (s (match-string 4))
	   (v (make-jcinfo :truename (match-string 5)
			   :name p
			   :url s
			   :signature (match-string 2))))
      (setf (gethash p *jtc-superclass-hash*) q)
      (setf (gethash (list p) *jtc-jcinfo-hash*) v)
      ; �����o�P�ʂŃ��[�v
      (while (looking-at "\\([^\n]*\\)\n\\([^\n]*\\)\n\\([^\n]*\\)\n\\([^\n]*\\)\n\\([^]*\\)\n")
	(goto-char (match-end 0))
	(let ((u (make-jcinfo :kind (match-string 1)
			      :return (match-string 2)
			      :truename (jcinfo-truename v)
			      :name (match-string 3)
			      :url (match-string 4)
			      :signature (concat (jcinfo-signature v) "\n" (match-string 5)))))
	  (setf (gethash (list p (jcinfo-name u)) *jtc-jcinfo-hash*) u)
	  (if (string-match "[mfl]" (jcinfo-kind u))
	      (pushnew (jcinfo-name u) r :test 'string=))))
      ; �����o�̐ݒ�
      (pushnew p *jtc-class-list* :test 'string=)
      (setf (gethash p *jtc-member-list-hash*) r)))
  ; �o�b�t�@�̉��
  (kill-buffer (ed::find-file-internal arg1)))
