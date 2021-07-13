;;; -*- Mode: Lisp; Package: user -*-
;;;
;;; jtc.l --- jtc��ni-autoload�p���W���[��

;;; author
;;;     YAMAMOTO Taizo

;;; date
;;;     Last updated: "2003-05-02"

;;; description
;;;     jtc��ni-autoload�p���W���[��

; �t�b�N�̐ݒ肪����̂�java���ɓǂݍ��ށB
; �����_�����g��Ȃ��̂�*java-mode-hook*�ɁA�����I�Ɋ֐������o����������B
(require "java")

; �p�b�P�[�W������ɐ錾����
(require "jtc/jtc-def")

; �c�[���o�[�͔C�ӂ̎��_�œǍ���
(autoload 'jtc::jtc-tool-bar "jtc/jtc" t)

; jtc�{�̂�java-mode����̋N�����ɓǂݍ���
(defun jtc-loadup-func () 
  (require "jtc/jtc"))
(add-hook '*java-mode-hook* 'jtc-loadup-func)