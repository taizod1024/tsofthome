;;; -*- Mode: Lisp; Package: user -*-
;;;
;;; irc.l --- irc-mode��ni-autoload�p���W���[��

;;; author
;;;     YAMAMOTO Taizo

;;; date
;;;     Last updated: "2003-04-30"

;;; description
;;;     irc-mode��ni-autoload�p���W���[��

; �p�b�P�[�W������ɐ錾����
(require "irc/irc-def")

; �c�[���o�[�͔C�ӂ̎��_�œǍ���
(autoload 'irc::irc-tool-bar "irc/irc-mode" t)
(autoload 'irc-mode "irc/irc-mode" t)
(autoload 'irc-connect "irc/irc-mode" t)