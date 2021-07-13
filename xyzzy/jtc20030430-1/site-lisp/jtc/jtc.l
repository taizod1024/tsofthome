;;; -*- Mode: Lisp; Package:jtc -*-
;;;
;;; jtc.l --- JavaTinyConsole
;;;

;;; author
;;;	YAMAMOTO Taizo

;;; date
;;;	Last updated: "2003-05-02"

;;; description
;;;	JAVA�p�ւȂ��傱���ł��B
;;;         
;;;	���̒����낢���JAVA�̊J����������܂����A�قƂ�ǊO���G�f�B�^
;;;	���g���Ȃ��̂ŁAxyzzy�p�Ɋ������܂����B
;;;	������Ƃ����v���O���������ɂ͏\�����ƁB
;;;

;;; requirement
;;;	1)xyzzy-0.2.1.212�ȍ~
;;;		popup-list���g�p���Ă��܂��̂ŁA����ȑO�̔łł͓��삵�܂���B
;;;	2)JDK 1.1/1.2/1.3-
;;;		�����ǂ̃o�[�W�����ł������Ǝv���܂��B
;;;	3)JDK�h�L�������g
;;;		http://java.sun.com/j2se/1.3/ja/docs/ja/
;;;		�ŎQ�Ƃł���h�L�������g�ł��B
;;;		API�̃��t�@�����X�̕\���Ɏg�p���܂��B
;;;		internet�ɐڑ����Ă���̂ł�����p�ӂ���K�v����܂���B
;;;	4)browser.dll
;;;		3)��\�����邽�߂ɕK�v�ł��B
;;;		�ʓr�A�g�ݍ���ŉ������B

;;; install
;;;	1)�𓀂�����ŁA�f�B���N�g��jtc/��$XYZZY/site-lisp/�ɃR�s�[���܂��B
;;;	2)jtc/make��load-file���܂��B
;;; 
;;;		------------------------------------------------
;;;		M-x load-file[RET]
;;;		Load file: $XYZZY/site-lisp/jtc/make.l[RET]
;;;		------------------------------------------------
;;; 
;;;	3)*.java��ǂݍ��񂾂Ƃ���jtc��L���ɂ��邽�߂ɁA
;;;	�@�ȉ��̃R�[�h�� ~/.xyzzy��������$XYZZY/site-lisp/siteinit.l�ɋL�q��ǉ����܂��B
;;;
;;;		------------------------------------------------
;;;		(require "java")
;;;		(require "jtc/jtc")
;;;		(define-key ed::*java-mode-map* #\F1 'jtc::jtc-info)
;;;		------------------------------------------------
;;;
;;;	  ��siteinit.l�ɋL�q�����ꍇ�ɂ͍ă_���v�����ĉ������B
;;; 
;;;	4)xyzzy���ċN�����܂��B

;;; uninstall
;;;	1)~/.xyzzy��������$XYZZY/site-lisp/siteinit.l��jtc�֘A�L�q���폜���܂��B
;;;	2)jtc/kill��load-file���܂��B
;;; 
;;;		------------------------------------------------
;;;		M-x load-file[RET]
;;;		Load file: $XYZZY/site-lisp/jtc/kill.l[RET]
;;;		------------------------------------------------
;;; 
;;;	3)$XYZZY/site-lisp/jtc/���폜���܂��B
;;;     4.��L�̐ݒ�𔽉f�����邽�߂ɁAxyzzy���ċN�����܂��B
;;;	  ��siteinit.l�ɋL�q�����ꍇ�ɂ͍ă_���v�����ĉ������B

;;; keybind
;;;	F1�L�[��jtc::jtc-info�ȊO�͌Œ�ł��B
;;; 
;;;	TAB 	jtc:jtc-do-completion
;;;		�N���X�E�����o���̕⊮
;;;		�N���X�E�����o�̃V�O�l�`���̃|�b�v�A�b�v�\��
;;;	F1	jtc:jtc-info
;;;		�N���X�E�����o�̃V�O�l�`���̃|�b�v�A�b�v�\��
;;;		�Ή�����JDK�h�L�������g�̕\��
;;;	( 	jtc:jtc-insert-open-paren
;;;		�����o�̃V�O�l�`���̃|�b�v�A�b�v�\��
;;;	#	jtc:jtc-insert-close-paren
;;;	)	jtc:jtc-insert-close-paren
;;; 	.	jtc:jtc-insert-close-paren
;;;	]	jtc:jtc-insert-close-paren
;;;		�N���X�̃|�b�v�A�b�v�\��
;;;

;;; feature
;;;	1)�t�@�C���̃R���p�C��
;;;	2)�f�B���N�g���z���̃R���p�C��
;;;	3)���C�N
;;;	4)���s
;;;	5)�N���X�E�����o�̃V�O�l�`���̃|�b�v�A�b�v�\��
;;;	6)�|�b�v�A�b�v�ɂ����͎x��
;;;	*.�����ɂ�������ۂ��M�~�b�N
;;;		���j���[
;;;		�c�[���o�[
;;;		�v���p�e�B�V�[�g
;;;		�|�b�v�A�b�v���X�g
;;;		JDK�h�L�������g�̕\��

;;; menu and toolbar
;;;	��{�I�Ɍ����܂܂ł��B
;;; 
;;;	��~(I)
;;;		���s���̃v���Z�X���I�������܂��B�I���ł�
;;; 		�Ȃ���Β��߂Ă��������B
;;;	�ꎞ�⊮ؽčX�V(T)
;;; 		���[�U��JAVA�t�@�C������⊮�p�̏�����
;;;		�����܂��B��������΁ASUN���񋟂��Ă���
;;;		�p�b�P�[�W�̃N���X�Ɠ��l�ɕ⊮�ł��܂��B
;;;		���R���p�C���G���[����������ꍇ�ɂ́A��
;;;		�����X�g�̍쐬�͎��s���܂��B
;;;

;;; property sheet
;;;	jtc�̊�{�I�ȏ��͂����炩��ݒ�ł��܂��B
;;; 
;;;	JDK�ިڸ��(O)
;;;		�i���g�p�j
;;;	JDK�޷����(P)
;;;		JDK�h�L�������g�̃p�X��ݒ肵�܂��BURL���\�ł��B
;;; 		��http://java.sun.com/j2se/1.3/ja/docs/ja/
;;;		�Ɠ����ʒu�ɂȂ�悤�ɐݒ肵�܂��B
;;;	���ނ�⊮(M)
;;;		�⊮�@�\�̎g�p�̗L����ݒ肵�܂��B
;;;	�̧�ݽ��\��(R)
;;;		JDK�h�L�������g�̕\���@�\�̎g�p�̗L����ݒ肵�܂��B
;;;	���߲�(C)
;;;		javac�R�}���h��ݒ肵�܂��B
;;;		�I�v�V�������K���ɕt���Ă��������B
;;;	���s(X)
;;;		java�R�}���h��ݒ肵�܂��B�K�v�ł���Έ�����ǉ����܂��B
;;;	���޸�(D)
;;;		jdb�R�}���h��ݒ肵�܂��B
;;;	Ҳ�(M)
;;;		�r���h�p�̃R�}���h��ݒ肵�܂��B
;;;	javadoc(J)
;;;		javadoc�R�}���h��ݒ肵�܂��B
;;; 

;;; known bugs
;;;	1)JDK�̓����ĂȂ�PC��[�ꎞ�⊮ؽčX�V(T)]���s���ƁA
;;; 	�@�v���Z�X���I�����Ȃ��ꍇ������B
;;;		���R�F�s��
;;;		���l�F������
;;;	2) non-static�ȃ����o������N���X���s�v�ȂƂ���ŕ⊮�����B
;;;		���R�F��ʂ��Ă��Ȃ�����
;;;		���l�F���Ȃ��A���Ȃ瑽����������蒼�����K�v
;;;	3)�z��ɑΉ��ł��Ȃ��B
;;;		���R�F��ʂ��Ă��Ȃ�����
;;;		���l�F���߂�
;;;	4)�ȉ���str���⊮�ł��Ȃ��B
;;;		���R�Fnarrow-to-term1��if()�̕����܂œǂ݂��ނ���B
;;;		���l�F���Ȃ�
;;;	    
;;;		if (true)
;;;			str.trim();
;;;		else
;;;			str.replace();
;;;	    
;;;	5)���X�ȉ��̋L�q�������������A�������������B
;;;		���R�Fnarrow-to-term1���_���_��������
;;;		���l�F���Ȃ�
;;;	    
;;;		String s.replace
;;;

;;; customize
;;;	1)���t�@�����X�\���p�Ƀt�b�N���p�ӂ��Ă��܂��B
;;;	�@������������΁Awww-mode��O����IE�ł̕\�����\�̔��ł��B
;;;		URL�����p	*jtc-info-url-hook*
;;;		URL�\���p	*jtc-info-hook*	    
;;;	2)�⊮���X�g
;;;		a.�⊮���X�g�쐬���@
;;;			�N���X�̕⊮���X�g��$XYZZY/site-lisp/jtc/complete/
;;;			�Ɋi�[���Ă��܂��B�⊮���X�g�̍쐬��
;;;			$XYZZY/site-lisp/jtc/doclet/makecomp.bat�����s���č쐬���܂��B
;;;			�Ǝ��̃p�b�P�[�W�̕⊮���X�g���쐬����ꍇ�ɂ́A
;;;			makecomp.bat���Q�l�ɂ��ĉ������B
;;;		b.�⊮���X�g�쐬�p�h�b�N���b�g
;;;			�⊮���X�g�̍쐬���̂ɂ̓h�b�N���b�g���g���Ă��܂��B
;;;			$XYZZY/site-lisp/jtc/doclet/ListClass.java�ł��B
;;;			$XYZZY/site-lisp/jtc/doclet/make.bat�ō쐬���܂��B
;;;

;;; changes
;;;	Fri, 02 May 2003 21:24:30 +0900
;;;		�EF1��jtc-info�Ƀf�t�H���g�Ńo�C���h����悤�ύX
;;;	Mon, 28 Apr 2003 06:17:35 +0900
;;;		�E�������̏C��
;;;		�E�c�[���o�[��$XYZZY/etc/�ɕύX
;;;	Sun, 22 Sep 2002 00:39:11 +0900
;;;		�E���K�\�����ꕔ�ύX
;;;	Fri, 09 Aug 2002 00:28:11 +0900
;;;		�E(autoload 'jtc::jtc-tool-bar "jtc/jtc")�Ńc�[���o�[����
;;;		�@autoload�ł���悤�ɕύX
;;;		�E�c�[���o�[��autoload�Ή��̈��*jtc-show-tool-bar*��p�~
;;;		�Exyzzy0.2.2.228����p�b�P�[�W�̃q�X�g���ϐ��̈������ς�����̂ŁA
;;;		�@�q�X�g���ϐ���S��user����jtc�Ɉڍs
;;;	Sun, 17 Mar 2002 09:09:33 +0900
;;;		�E�c�[���o�[��jtc/kill�ō폜
;;;		�Ejtc/kill�̍ۂ�*jtc-javadoc-history*��������ĂȂ��̂��C��
;;;		�E���j���[�̕\���ʒu���O�����Ȃ̂Ō��̕��Ɉړ�
;;;		�E�I�����̏�Ԃ�ۑ����Ă���Ƃ��ɁA�ċN�����jtc���L���ɂȂ�Ȃ��̂��C��
;;;		�@���Z�b�V�����𕜌�����Ƃ���jtc���Ăяo�����B
;;;		�@�@�Z�b�V�����̕����̓��j���[�������O�ɍs����̂�����
;;;		�@�@�������[�h����Ă��ǂ��悤�ɏC��
;;;	Sun, 13 Jan 2002 23:51:11 +0900
;;;		�Ejtc/make�����s����̂��C���i�����͂��j
;;;		�E�ʓ|�������̂�Readme.txt����荞��
;;;	Sun, 21 Oct 2001 14:19:08 +0900�i�����ɏC���j
;;;		�E*jtc-jdk-document-directory*�����X�g�ɂ�����q�X�g���ϐ����肪���������Ȃ����B
;;;		�@jtc/kill�ŃN���A����Bjtc/make�ŕϊ�����i���j�B
;;;	Thu, 18 Oct 2001 17:42:15 +0900�i�����ɏC���j
;;;		�EJDK�h�L�������g�̃p�X�w����R���{�{�b�N�X��
;;;		�E�}�N�����L�邱�Ƃ�Y��Ă����̂ŁA�o�C�g�R���p�C������𒲐�
;;;	Mon, 15 Oct 2001 23:48:59 +0900
;;;		�E"super"��"this"�̈�����ύX
;;;		�E"str.trim()."�̈ʒu�ł�jtc-info�̃G���[���C��
;;;	Sun, 14 Oct 2001 22:58:50 +0900
;;;		�E����

;;; todo
;;;	1)�R�����g�̕t�������A�����������ꂢ�ɁB
;;;	2)JDK�̖����}�V���ňꎞ�⊮���X�g���X�V����ƌł܂�H

;;; done
;;;	1)URL�������Ƃ���B�܂�Adoclet��ListClass.java���C������B
;;;	�@�ˈꉞ�AJDK�h�L�������g��������悤�ɂȂ����B
;;;	2)�Ǝ��A�C�R���̍쐬�A�R���p�C���E���s�̋�ʂ𖾊m�ɁB
;;;	3)errors.l��scanner�����B����ŁA�G���[�����n�C���C�g�ł���B
;;;	�@*find-error-scanner*�̒���(match-string 0)�����悤�ɓ����B
;;;	4)���[�J���̃f�B���N�g����Ώۂɕ⊮���X�g���쐬����B  
;;;	5)�⊮���X�g�̍ēǂݍ��݁ˁ~
;;;	6)JDK�h�L�������g��URL�Ή�
;;;	7)�⊮���X�g�̒x���ǂݍ���

(provide "jtc/jtc")

(require "jtc/jtc-def")
(require "jtc/jtc-shell")
(require "jtc/jtc-menu")
(require "jtc/jtc-complete")