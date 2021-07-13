;;; -*- Mode: lisp; Package: irc -*-
;;;
;;; irc-tool-bar --- client side irc module : tool bar option

;;; author
;;;     YAMAMOTO Taizo

;;; date
;;;     Last updated: "2003-04-29"

;;; description
;;;	�c�[���o�[��ǉ����܂��B
;;;	��Ԃ�\�����邱�Ƃ�ړI�Ƃ��Ă��܂��B

;;; changes
;;;	Sun, 07 Jul 2002 09:18:24 +0900
;;;		����

(eval-when (:compile-toplevel :load-toplevel :execute)
  (unless (find-package "irc")
    (defpackage "irc"
      (:nicknames "irc")
      (:use "lisp" "editor")))
  (require "irc/irc")
  (require "irc/irc-dialog"))

(provide "irc/irc-tool-bar")

(in-package "irc")

;;; ------------------------------------------------
;;; function
;;; ------------------------------------------------

(defun irc-tool-bar-send-away ()
  "irc: �c�[���o�[����SEND�y��AWAY�����s"
  (interactive)
  (irc-send-away-and-nick :toggle *irc-away-message*))

(defun irc-tool-bar-hold-buffer ()
  "irc: �c�[���o�[����\���ʒu�̌Œ�����s"
  (interactive)
  (cond ((eq buffer-mode 'irc-log-mode)
	 (irc-hold-buffer))
	((eq buffer-mode 'irc-dialog-mode)
	 (irc-dialog-hold-buffer))))

(defun irc-tool-bar-update-send-away ()
  "irc: �c�[���o�[��AWAY��Ԃ̍X�V�p"
  (cond ((not (find buffer-mode *irc-mode*)) :disable)
	((not (irc-is-connected)) :disable)
	(*irc-away* :check)))

(defun irc-tool-bar-update-hold-buffer ()
  "irc: �c�[���o�[�̕\���ʒu��Ԃ̍X�V�p"
  (cond ((not (find buffer-mode *irc-mode*)) :disable)
	((not (irc-is-connected)) :disable)
	(irc-buffer-hold :check)))

;;; ------------------------------------------------
;;; tool bar
;;; ------------------------------------------------

(defun irc-tool-bar ()
  "irc: �c�[���o�[�̍쐬"
  (create-tool-bar 'irc-tool-bar
		   (merge-pathnames "toolbar-irc.bmp" (etc-path))
		   '(("AWAY+NICK" 0 irc-tool-bar-send-away irc-tool-bar-update-send-away)
		     ("�J�[�\���Œ�" 1 irc-tool-bar-hold-buffer irc-tool-bar-update-hold-buffer))))
(define-command-bar 'irc-tool-bar "irc-mode(&C)")