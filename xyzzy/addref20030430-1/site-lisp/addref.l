;;; -*- Mode: Lisp; Package: editor -*-
;;;
;;; addref.l --- ���t�@�����X�쐬�x��

;;; author
;;;   original by
;;;	quarto <quarto@livedoor.com>
;;;  arranged by
;;;	YAMAMOTO Taizo <ymtz@pop02.odn.ne.jp>

;;; date
;;;	Last updated: 2002/02/09 21:33:19 +0900

;;; description
;;;	���t�@�����X�̍쐬�x���̃c�[���ł��B

;;; note
;;;	�ւȂ��傱���t�@�����X�́A�팩����E��������Ǝ󂯌p����A���݂�
;;;	��v�ۂ���̃T�C�g�Ō��J����Ă��܂��B
;;;	info, info-modoki, HTML���̂��܂��܌`���ł̗��p��z�肵�āA
;;;	XML(reference.xml)+�ϊ��c�[���ɂ��\������Ă��܂��B
;;;
;;;	add-ref.l�́Aquarto����ɂ���č쐬����A2001/04/01��xyzzy ML�ɓ��e����܂����B
;;;	reference.xml�֍ŏI�I�Ƀ}�[�W���邽�߂̕ҏW�p��XML�t�@�C�����A�ȒP�Ƀ����e�i���X
;;;	���邽�߂̂��̂ł��B
;;;
;;;	addref.l�́Aaddref.l������YAMAMOTO Taizo�ɂ��A�����W�������̂ł��B

;;; install
;;;	1.�𓀂���addref.l��$XYZZY/site-lisp�ɃR�s�[���܂��B
;;;	2.�o�C�g�R���p�C�����܂��B
;;;
;;;		--------------------------------
;;;		M-x byte-compile-file
;;;		--------------------------------
;;;
;;;	3.~/.xyzzy��������$XYZZY/site-lisp/siteinit.l�ɋL�q��ǉ����܂��B
;;;	�@���������߂邽�߂�XML�t�@�C��(*addref-file*)�͏���ɍ쐬����܂��B
;;;
;;;		--------------------------------
;;;		(require "addref")
;;;		--------------------------------
;;;
;;;	4.��L�̐ݒ�𔽉f�����邽�߂ɁAxyzzy���ċN�����܂��B

;;; keybind
;;;	C-x C-s	�ۑ��y�щ�ʕ��A

;;; usage
;;;	�z�肵�Ă���g�����͈ȉ��̓�ʂ�ł��B
;;;
;;;	1.info-modoki�̗l�ɁA�P����addref-any�����s����B
;;;	2.addref, addref-function, addref-variable�����s���A������^�V���{������͂���B
;;;
;;;	���͂��ꂽ������^�V���{�������o�^�Ȃ�΁A�V�K�쐬�̊m�F�_�C�A���O���\������܂��B
;;;	info-modoki�ɋ߂����o�Ń����e�i���X���o����Ǝv���܂��B
;;;	���Ȃ݂ɁAseealso��link�͒l��A�����͉\�ł��B�������͂�����ENTER����ƏI���ł��B

;;; note
;;;	1.reference.xml���x�[�X�ɕҏW���悤�Ǝv���ƌ����ɂ�����Ǝ��Ԃ��|����܂��B
;;;	�@�o����Εʃt�@�C���ō�Ƃ��s�����Ƃ����E�߂��܂��B
;;;	2.�Z�N�V��������͂����낵�����������ł��B
;;;	�@���e���m�F������őI�����Ă��������B
;;;	�@�܂��A���o���I�ɓK�؂Ȕ��胋�[�`��������΋����Ă��������B

;;; changes
;;;	Wed, 30 Apr 2003 23:14:52 +0900
;;;		�E*addref-file*�̊i�[�ʒu��$XYZZY/site-lisp/����$XYZZY/etc/�ɕύX
;;;	Mon, 28 Apr 2003 00:30:21 +0900
;;;		�E*addref-filename*��*addref-file*�ɕύX
;;;	Wed, 20 Feb 2002 00:22:41 +0900
;;;		�Eaddref-function-1����*addref-function�ɕύX
;;;		�Eaddref-variable-1����*addref-variable�ɕύX
;;;		�E*addref��ǉ�
;;;		�Eaddref-search-file�ōs����setq�����o����悤�ɕύX
;;;		�Eaddref-get-type����"Symbol"���폜
;;;	Fri, 15 Feb 2002 01:33:06 +0900
;;;		�E�v�������Ă��낢��ƕ⊮��ǉ��iYAMAMOTO Taizo�ɂ��C���j
;;;		�@�}�C�i�[���[�h�ɕύX�ixml-mode�ł̎g�p��z��j
;;;		�@*delete-buffer-hook*�ł��E�B���h�E�z�u�̕��A�ōs���悤�ɕύX
;;;		�@���\���l�����āA�ۑ����Ă����Ȃ��悤�ɕύX
;;;	Sun, 1 Apr 2001 01:11:57 +0900
;;;		�E���Łiquarto����ɂ��xyzzy ML�ɓ��e���ꂽ�j

(provide "addref")

;;;
;;; ���낢��
;;;

(defvar *addref-file* (merge-pathnames "addref.xml" (etc-path))
  "addref: ���t�@�����X�ҏW�p��XML�t�@�C��")
(defvar *addref-search-path* (merge-pathnames "lisp" (si::system-root))
  "addref: ��`�̌����p�X")
(defvar *addref-window-height* 15
  "addref: �ҏW�E�B���h�E�̑傫��")

(defvar *addref-ask-type* t
  "addref: �V�K�쐬���̃^�C�v�̖₢���킹")
(defvar *addref-ask-arguments* t
  "addref: �V�K�쐬���̈����̖₢���킹")
(defvar *addref-ask-package* t
  "addref: �V�K�쐬���̃p�b�P�[�W�̖₢���킹")
(defvar *addref-ask-seealso* t
  "addref: �V�K�쐬����SEEALSO�̖₢���킹")
(defvar *addref-ask-link* nil
  "addref: �V�K�쐬���̃����N�̖₢���킹")
(defvar *addref-ask-section* t
  "addref: �V�K�쐬���̃Z�N�V�����̖₢���킹")
(defvar *addref-ask-file* nil
  "addref: �V�K�쐬���̃t�@�C���̖₢���킹")
(defvar *addref-type-list* '("Function" "Variable" "Macro" "Misc"
			     "Keyword" "Special Form" "BufferLocal" "Tips")
  "addref: �^�C�v�ꗗ")
(defvar *addref-section-list* '("�f�[�^�^" "�ϐ��ƒ萔" "����\��"
				"�p�b�P�[�W" "�֐�" "�}�N��" "�V���{��"
				"���l" "����" "������" "�V�[�P���X"
				"���X�g" "�n�b�V��" "�z��" "�`�����N"
				"�]��" "���o��" "�t�@�C���V�X�e��"
				"�G���[" "�E�B���h�E" "�o�b�t�@"
				"�~�j�o�b�t�@" "���[�W����" "���[�h"
				"�V���^�b�N�X" "�L�[�}�b�v" "�e�L�X�g"
				"�����E���K�\��" "�_�C�A���O" "���t�E����"
				"���j���[" "�t�@�C���[" "�|�W�V����"
				"�v���Z�X" "�V�X�e��" "���̑�")
  
  "addref: �Z�N�V�����ꗗ")
(defvar *addref-popup-completion-list* t
  "addref: �⊮���Ƀ|�b�v�A�b�v���X�g���g�p")

(defvar *addref-mode-map* nil
  "addref: �}�C�i�[���[�h�p�L�[�}�b�v")
(unless *addref-mode-map*
  (setq *addref-mode-map* (make-sparse-keymap))
  (define-key *addref-mode-map* '(#\C-x #\C-s) 'addref-end))

(defvar-local *addref-mode* nil)
(pushnew '(*addref-mode* . "AddRef") *minor-mode-alist* :key 'car)

(defstruct addref-topic
  title type arguments package desc seealso link section file)

;;;
;;; UI
;;;

;;; lisp-info-F1�̂悤�Ȃ��̂�z��
(defun addref-any ()
  "addref: �|�C���g���當������擾"
  ; ������info-modoki.l����q��
  (interactive)
  (let (beg end)
    (save-excursion
      (setq end (progn
		  (or (skip-syntax-spec-forward "w_j")
		      (skip-syntax-spec-backward "^w_j"))
		  (point)))
      (setq beg (progn
		  (skip-syntax-spec-backward "w_j")
		  (when (looking-at "^��")
		    (forward-char 1))
		  (point))))
    (unless (= beg end)
      (addref (buffer-substring beg end))))
  ;������
  )

;;; �֐��p
(defun addref-function ()
  "addref: �֐���p�̃��t�@�����X�ǉ�"
  (interactive)
  (let ((*minibuffer-popup-completion-list* *addref-popup-completion-list*))
    (call-interactively '*addref-function)))
(defun *addref-function (func)
  (interactive "aaddref-function: ")
  (addref func))

;;; �ϐ��p
(defun addref-variable ()
  "addref: �ϐ���p�̃��t�@�����X�ǉ�"
  (interactive)
  (let ((*minibuffer-popup-completion-list* *addref-popup-completion-list*))
    (call-interactively '*addref-variable)))
(defun *addref-variable (var)
  (interactive "vaddref-variable: ")
  (addref var))

;;; �ėp
(defun addref (&optional str-or-sym)
  "addref: �ėp�̃��t�@�����X�ǉ�"
  (interactive)
  (let ((*minibuffer-popup-completion-list* *addref-popup-completion-list*))
    (funcall '*addref str-or-sym)))
(defun *addref (&optional str-or-sym)
  (interactive)
  (let ((tlst (addref-get-title-list))
	str sym)
    ; ���͂��^�C�g���ƃV���{���ɕϊ�
    (unless str-or-sym
      (setq str-or-sym (completing-read "addref: " tlst)))
    (cond ((symbolp str-or-sym)
	   (setq sym str-or-sym)
	   (setq str (addref-symbol-name sym)))
	  ((find-symbol str-or-sym)
	   (setq sym (find-symbol str-or-sym))
	   (setq str (addref-symbol-name sym)))
	  (t
	   (setq sym nil)
	   (setq str str-or-sym)))
    ; ���͂ɉ����Ċe�G���g���𖄂߂Ă���ҏW���[�h�ֈڍs
    (cond ; �����̃^�C�g��
	  ((find str tlst :test 'string=)
	   (addref-fix str))
	  ; �V�K�쐬�̃^�C�g��
	  ((yes-or-no-p "~A\n\n��������܂���A�V�K�ɍ쐬���܂����H" str)
	   (let ((tpc (make-addref-topic)))
	     ; �V���{���Ȃ�K���ɖ��߂�
	     (if sym
		 (addref-set-symbol-to-topic sym tpc)
	       (setf (addref-topic-title tpc) str))
	     ; type
	     (when *addref-ask-type*
	       (message "completing ... type list")
	       (setf (addref-topic-type tpc)
		     (completing-read (format nil "~A ... type: " str)
				      *addref-type-list*
				      :default (addref-topic-type tpc)
				      :must-match t)))
	     ; arguments
	     (when *addref-ask-arguments*
	       (unless (find-if #'(lambda (x) (string= x (addref-topic-type tpc)))
				'("Variable" "BufferLocal" "Tips"))
		 (setf (addref-topic-arguments tpc)
		       (completing-read (format nil "~A ... arguments: " str)
					nil :default (addref-topic-arguments tpc)))))
	     ; package
	     (when *addref-ask-package*
	       (unless (find-if #'(lambda (x) (string= x (addref-topic-type tpc)))
				'("Tips"))
		 (message "completing ... package list")
		 (setf (addref-topic-package tpc)
		       (completing-read (format nil "~A ... package: " str)
					(mapcar 'package-name (list-all-packages))
					:default (addref-topic-package tpc)))))
	     ; seealso
	     (when *addref-ask-seealso*
	       (message "completing ... topic list")
	       (let (val olst (ilst (addref-topic-seealso tpc)))
		 (loop
		   (setq val
			 (completing-read (format nil "~A ... seealso #~D: "
						  str (1+ (length olst)))
					  tlst :default (pop ilst)))
		   (cond ((string/= val "")
			  (pushnew val olst :test 'string=))
			 ((null ilst)
			  (return)))
		   (message "seealso:~{ ~A~}" olst))
		 (setf (addref-topic-seealso tpc) olst)))
	     ; link
	     (when *addref-ask-link*
	       (message "completing ... link list")
	       (let (val olst (ilst (addref-topic-link tpc)))
		 (loop
		   (setq val
			 (completing-read (format nil "~A ... link #~D: "
						  str (1+ (length olst)))
					  nil :default (pop ilst)))
		   (cond ((string/= val "")
			  (pushnew val olst :test 'string=))
			 ((null ilst)
			  (return)))
		   (message "link:~{ ~A~}" olst))
		 (setf (addref-topic-link tpc) olst)))
	     ; section
	     (when *addref-ask-section*
	       (setf (addref-topic-section tpc)
		     (completing-read (format nil "~A ... section: " str)
				      *addref-section-list*
				      :default (addref-topic-section tpc)
				      :must-match t)))
	     ; file
	     (if (yes-or-no-p "�t�@�C�����������܂����H") ; sym�����鎞�����ł��������c
	       (setf (addref-topic-file tpc) (addref-search-file str))
	       (if *addref-ask-file*
		   (setf (addref-topic-file tpc)
			 (completing-read "file: " nil))))
	     (addref-add tpc)
	     (addref-fix tpc)))
	  ; �Y���Ȃ�
	  (t nil))))

;;;
;;; �ҏW
;;;

(defvar *addref-winconf* nil)

(defun addref-add (tpc)
  "addref: �o���オ������̃g�s�b�N���o�b�t�@�ɒǉ�"
  (save-excursion
    (set-buffer (ed::find-file-internal *addref-file*))
    (widen)
    (goto-char (point-min))
    (with-output-to-selected-buffer
      (addref-output-topic-format tpc))))

(defun addref-fix (tpc-or-str)
  "addref: �o���オ������̃g�s�b�N��ҏW�J�n"
  ; �E�B���h�E�z�u�̑ޔ�
  (unless *addref-winconf*
    (setq *addref-winconf* (current-window-configuration)))
  ; �ҏW�t�@�C�����J�����g�o�b�t�@�֕ύX
  (let ((buf (ed::find-file-internal *addref-file*)))
    (unless (eq (selected-buffer) buf)
      (delete-other-windows)
      (pop-to-buffer buf *addref-window-height*)))
  ; �^�C�g���̌����E�͈͌���E�ړ�
  (widen)
  (goto-char (point-min))
  (when (scan-buffer
	 (concat "<title>"
		 (if (addref-topic-p tpc-or-str)
		     (addref-topic-title tpc-or-str)
		   tpc-or-str)
		 "</title>"))
    (narrow-to-region
     (progn (scan-buffer "<chapter>" :reverse t :tail nil) (point))
     (progn (scan-buffer "</chapter>\n" :tail t) (point)))
    (unless (prog1 (buffer-modified-p) (addref-decode-entity))
      (not-modified))
    (scan-buffer "<description>\n" :reverse t :tail t)
    (skip-chars-forward " \t");
    (recenter 6) ; chapter-description��6�s
    ; addref-mode�̊J�n
    (ed::toggle-mode '*addref-mode* t t)
    (update-mode-line t)
    (set-minor-mode-map *addref-mode-map*)))

(defun addref-end ()
  "addref: �ҏW����"
  (interactive)
  (let ((buf (find-buffer (file-namestring *addref-file*))))
    ; �o�b�t�@�����݂�addref-mode�̏ꍇ����
    (when (and buf *addref-mode*)
      (set-buffer buf)
      (narrow-to-region
       (progn (scan-buffer "<chapter>" :reverse t :tail nil) (point))
       (progn (scan-buffer "</chapter>\n" :tail t) (point)))
      (addref-encode-entity)
      (widen)
      (save-buffer)
      ; addref-mode�̏I��
      (ed::toggle-mode '*addref-mode* nil t)
      (update-mode-line t)
      (unset-minor-mode-map *addref-mode-map*)
      ; �E�B���h�E�z�u�̕��A
      (when *addref-winconf*
	(set-window-configuration *addref-winconf*)
	(setq *addref-winconf* nil)))))

(add-hook '*delete-buffer-hook*
	  #'(lambda (buf)
	      ; �ޔ������E�B���h�E�z�u������addref-mode�̏ꍇ����
	      ; ��kill-buffer�΍�
	      (when (and *addref-mode*
			 *addref-winconf*)
		(set-window-configuration *addref-winconf*)
		(setq *addref-winconf* nil))
	      t))

(defun addref-get-title-list ()
  "addref: �^�C�g���̃��X�g���擾���܂�"
  (let (lst)
    (save-excursion
      (set-buffer (ed::find-file-internal *addref-file*))
      (save-excursion
	(save-restriction
	  (widen)
	  (goto-char (point-min))
	  (while (scan-buffer "<title>\\(.*\\)</title>" :regexp t :no-dup t :tail t)
	    (pushnew (match-string 1) lst :test 'string=)))))
    lst))

;;;
;;; �g�s�b�N�̑���
;;;

(defun addref-retrieve-topic (tpc)
  "addref: �g�s�b�N�𒊏o���č\���̂Ɋi�[���܂��B"
  (save-excursion
    (save-restriction
      (widen)
      (narrow-to-region
       (progn (scan-buffer "<chapter>" :reverse t :tail nil) (point))
       (progn (scan-buffer "</chapter>\n" :tail t) (point)))
      (let* (ttitle ttype targuments tpackage tdesc tseealso tlink tsection tfile str end)
	(goto-char (point-min))
	(and (scan-buffer "<title>\\(.*\\)</title>" :regexp t :tail t)
	     (setq ttitle (match-string 1)))
	(goto-char (point-min))
	(and (scan-buffer "<type>\\(.*\\)</type>" :regexp t :tail t)
	     (setq ttype (match-string 1)))
	(goto-char (point-min))
	(and (scan-buffer "<arguments>\\(.*\\)</arguments>" :regexp t :tail t)
	     (setq targuments (match-string 1)))
	(goto-char (point-min))
	(and (scan-buffer "<package>\\(.*\\)</package>" :regexp t :tail t)
	     (setq tpackage (match-string 1)))
	(goto-char (point-min))
	(and (integerp
	      (setq str (and (scan-buffer "<description>\n?" :regexp t :tail t)
			     (match-end 0))))
	     (integerp
	      (setq end (and (scan-buffer "\n?</description>" :regexp t :tail nil)
			     (match-beginning 0))))
	     (setq tdesc (buffer-substring str end)))
	(goto-char (point-min))
	(while (and (integerp
		     (setq str (and (scan-buffer "<seealso>\n?" :regexp t :tail t)
				    (match-end 0))))
		    (integerp
		     (setq end (and (scan-buffer "\n?</seealso>" :regexp t :tail nil)
				    (match-beginning 0)))))
	  (pushnew (buffer-substring str end) tseealso :test 'string=))
	(goto-char (point-min))
	(and (scan-buffer "<link>\\(.*\\)</link>" :regexp t :tail t)
	     (setq tlink (match-string 1)))
	(goto-char (point-min))
	(while (and (integerp
		     (setq str (and (scan-buffer "<section>\n?" :regexp t :tail t)
				    (match-end 0))))
		    (integerp
		     (setq end (and (scan-buffer "\n?</section>" :regexp t :tail nil)
				    (match-beginning 0)))))
	  (pushnew (buffer-substring str end) tsection :test 'string=))
	(goto-char (point-min))
	(and (scan-buffer "<file>\\(.*\\)</file>" :regexp t :tail t)
	     (setq tfile (match-string 1)))
	(setf (addref-topic-title tpc) ttitle)
	(setf (addref-topic-type tpc) ttype)
	(setf (addref-topic-arguments tpc) targuments)
	(setf (addref-topic-package tpc) tpackage)
	(setf (addref-topic-desc tpc) tdesc)
	(setf (addref-topic-seealso tpc) tseealso)
	(setf (addref-topic-link tpc) tlink)
	(setf (addref-topic-section tpc) tsection)
	(setf (addref-topic-file tpc) tfile))))
  tpc)

(defun addref-output-topic-format (tpc)
  (format t "<chapter>\n")
  (format t "<title>~A</title>\n" (or (addref-topic-title tpc) ""))
  (format t "<type>~A</type>\n" (or (addref-topic-type tpc) ""))
  (format t "<arguments>~A</arguments>\n" (or (addref-topic-arguments tpc) ""))
  (format t "<package>~A</package>\n" (or (addref-topic-package tpc) ""))
  (format t "<description>\n~A\n</description>\n" (or (addref-topic-desc tpc) ""))
  (format t "~{<seealso>~A</seealso>\n~}" (or (addref-topic-seealso tpc) '("")))
  (format t "~{<link>~A</link>~}\n" (or (addref-topic-link tpc) '("")))
  (format t "<section>~A</section>\n" (or (addref-topic-section tpc) ""))
  (format t "<file>~A</file>\n" (or (addref-topic-file tpc) ""))
  (format t "</chapter>\n\n"))

(defun addref-set-symbol-to-topic (sym tpc)
  (let* ((ttitle (addref-symbol-name sym))
	 (ttype (addref-get-type sym))
	 (targuments (addref-get-arguments sym))
	 (tpackage (addref-get-package-name sym))
	 tdesc
	 tseealso
	 tlink
	 (tsection (addref-guess-section ttitle targuments))
	 tfile)
    (setf (addref-topic-title tpc) ttitle)
    (setf (addref-topic-type tpc) ttype)
    (setf (addref-topic-arguments tpc) targuments)
    (setf (addref-topic-package tpc) tpackage)
    (setf (addref-topic-desc tpc) tdesc)
    (setf (addref-topic-seealso tpc) tseealso)
    (setf (addref-topic-link tpc) tlink)
    (setf (addref-topic-section tpc) tsection)
    (setf (addref-topic-file tpc) tfile)))

;;;
;;; ���̎Q�Ƃ̃G���R�[�h�E�f�R�[�h
;;;

(defvar *addref-tag-list*
  '("<chapter>" "<title>" "<type>" "<arguments>" "<description>"
    "<package>" "<seealso>" "<section>" "<link>" "<file>"
    "</chapter>" "</title>" "</type>" "</arguments>" "</description>"
    "</package>" "</seealso>" "</section>" "</link>" "</file>"
    "<!--" "-->"))
(defun addref-encode-entity ()
  (long-operation
    (save-excursion
      (goto-char (point-min))
      (while (scan-buffer "&\\|<\\|>" :no-dup t :regexp t :tail nil)
	(cond ((looking-for "&")
	       (unless (find-if 'looking-for '("&amp;" "&lt;" "&gt;"))
		 (forward-char)
		 (insert "amp;")
		 (backward-char)))
	      ((looking-for "<")
	       (unless (find-if 'looking-for *addref-tag-list*)
		 (delete-char)
		 (insert "&lt;")
		 (backward-char)))
	      ((looking-for ">")
	       (forward-char)
	       (unless (find-if 'looking-back *addref-tag-list*)
		 (delete-char -1)
		 (insert "&gt;")
		 (backward-char))))))))

(defun addref-decode-entity ()
  (long-operation
    (save-excursion
      (goto-char (point-min))
      (perform-replace "&amp;" "&" nil nil nil t)
      (goto-char (point-min))
      (perform-replace "&lt;" "<" nil nil nil t)
      (goto-char (point-min))
      (perform-replace "&gt;" ">" nil nil nil t))))

(defun addref-decode-entity-string (str)
  (substitute-string str "&amp;" "&")
  (substitute-string str "&lt;" "<")
  (substitute-string str "&gt;" ">"))

;;;
;;; �V���{������e������擾
;;;

(defun addref-symbol-name (sym)
  (concat (and (keywordp sym) ":") (symbol-name sym)))

(defun addref-get-type (sym)
  (setq ttype
	(cond ((special-form-p sym) "Special Form")
	      ((macro-function sym) "Macro")
	      ((fboundp sym) "Function")
	      ((keywordp sym) "Keyword")
	      ((boundp sym)
	       (cond ((local-variable-p sym) "BufferLocal")
		     (t "Variable")))
	      (t "Misc"))))

(defun addref-get-arguments (sym)
  (when (fboundp sym)
    (let ((def (symbol-function sym))
	  (name (symbol-name sym))
	  args)
      ;������describe-function���炻�̂܂�
      (cond ((si:*builtin-function-p def)
	     (setq args (get sym 'si::builtin-function-argument)))
	    (t
	     (if (si:*closurep def)
		 (setq def (si:closure-body def)))
	     (when (or (eq (safe-car def) 'lambda)
		       (eq (safe-car def) 'macro))
	       (setq args (safe-cadr def)))))
      ;������
      (with-output-to-string (so)
	(let ((*standard-output* so))
	  (format t "~a" name)
	  ;������describe-function���炻�̂܂�
	  (if (stringp args)
	      (format t " ~a" args)
	    (labels ((print-sexp (sexp)
		       (cond ((null sexp)
			      (princ "()"))
			     ((listp sexp)
			      (cond ((eq (car sexp) 'quote)
				     (princ "'")
				     (print-sexp (cadr sexp)))
				    ((eq (car sexp) 'function)
				     (princ "#'")
				     (print-sexp (cadr sexp)))
				    (t
				     (print-list sexp "(")
				     (princ ")"))))
			     ((member sexp lambda-list-keywords)
			      (format t "~a" sexp))
			     ((keywordp sexp)
			      (format t ":~:@(~a~)" sexp))
			     (t
			      (format t "~:@(~a~)" sexp))))
		     (print-list (args prefix)
		       (dolist (arg args)
			 (princ prefix)
			 (print-sexp arg)
			 (setq prefix " "))))
	      (print-list args " ")))
	  ;������
	  )))))

(defun addref-get-package-name (sym)
  (package-name (symbol-package sym)))

(defun addref-guess-section (ttitle &optional targ)
  (string-matchp "^*?\\(.*\\)*?$" ttitle)
  (setq ttitle (match-string 1))
  (cond ; �m�x����
	((string-matchp "filer" ttitle) "�t�@�C���[")
	((string-matchp "hash" ttitle) "�n�b�V��")
	((string-matchp "array" ttitle) "�z��")
	((string-matchp "package" ttitle) "�p�b�P�[�W")
	((string-matchp "syntax" ttitle) "�V���^�b�N�X")
	((string-matchp "menu" ttitle) "���j���[")
	((string-matchp "dialog" ttitle) "�_�C�A���O")
	((string-matchp "process" ttitle) "�v���Z�X")
	((string-matchp "window\\|screen" ttitle) "�E�B���h�E")
	((string-matchp "stream$" ttitle) "���o��")
	((string-matchp "\\(tool\\|command\\|tab\\)-bar" ttitle) "���j���[")
	((string-matchp "[^euxmolaih]p$" ttitle) "�f�[�^�^")
	((string-matchp "^with-[io]" ttitle) "���o��")
	; �������v
	((string-matchp "-char$" ttitle) "����")
	((string-matchp "column\\|point" ttitle) "�|�W�V����")
	((string-matchp "c[ad]+r$" ttitle) "���X�g")
	((string-matchp "replace\\|match" ttitle) "�����E���K�\��")
	((string-matchp "mode$" ttitle) "���[�h")
	; �������˓I
	((string-matchp "macro" ttitle) "�}�N��")
	((string-matchp "region" ttitle) "���[�W����")
	((string-matchp "minibuffer" ttitle) "�~�j�o�b�t�@")
	((string-matchp "string" ttitle) "������")
	((string-matchp "path-?name\\|directory" ttitle) "�t�@�C���V�X�e��")
	((string-matchp "time\\|date" ttitle) "���t�E����")
	; �c�蕨
	((string-matchp "system" ttitle) "�V�X�e��")
	((string-matchp "seq" ttitle) "�V�[�P���X")
	((string-matchp "eval" ttitle) "�]��")
	((string-matchp "stream" ttitle) "���o��")
	((string-matchp "error" ttitle) "�G���[")
	((string-matchp "mode" ttitle) "���[�h")
	((string-matchp "keymap" ttitle) "�L�[�}�b�v")
	; ��������
	((null targ))
	((string-matchp "regexp\\|pattern" targ) "�����E���K�\��")
	((string-matchp "list" targ) "���X�g")
	((string-matchp "form" targ) "����\��")
	((string-matchp "seq" targ) "�V�[�P���X")))

(require "grepd")
(defun addref-search-file (str)
  (let ((ed::*grep-case-fold-search* nil)
	(ed::*grep-word-search* nil)
	(ed::*grep-regexp-search* t)
	(ed::*grep-understand-escape-sequences* nil)
	(ed::*grep-subdir* t)
	(ed::*grep-async* nil)
	(ed::*grep-name-only* nil)
	(w (current-window-configuration))
	(rexp (concat "\\(defconstant\\|defvar\\|setq-default\\|defun\\|defun-builtin\\|defmacro\\|^(setq\\) "
		      (regexp-quote str)
		      " ?")))
    (ed::scan-files rexp "*.l" *addref-search-path*)
    (switch-to-buffer "*grep*")
    (prog1
	(if (eq (point-min) (point-max))
	    nil
	  (buffer-substring
	   (point-min)
	   (progn (scan-buffer ":[0-9]+:" :regexp t :tail nil) (point))))
      (set-window-configuration w))))

;;;
;;; ���܂�
;;;
(defun addref-title-list-to-temp-buffer ()
  "addref: reference.xml�̓��e����^�C�g���̃��X�g�����B"
  (interactive)
  (with-output-to-temp-buffer ("*addref title*")
    (format t "~{~A\n~}" (addref-decode-entity-string (addref-get-title-list)))))