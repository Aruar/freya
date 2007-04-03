@echo off

rem bat �t�@�C�����猩�� Athena �̃t�H���_�iReadme ������t�H���_�j
set ATHENAPATH=..\..\

rem bat �t�@�C�����猩���A���s�t�@�C��������t�H���_
set BINPATH=%ATHENAPATH%
rem set BINPATH=%ATHENAPATH%bin\

rem Athena �t�H���_���猩���A���O�t�@�C���̃t�H���_
set LOGPATH=./log/

rem ���s�t�@�C��
set L_SRV=%BINPATH%login-server
set C_SRV=%BINPATH%char-server
set M_SRV=%BINPATH%map-server

rem �R���t�B�O�t�@�C��
set L_SRV_C=./conf/login_athena.conf
set C_SRV_C=./conf/char_athena.conf
set C_SRV_C2=./conf/inter_athena.conf
set M_SRV_C=./conf/map_athena.conf
set M_SRV_C2=./conf/battle_athena.conf
set M_SRV_C3=./conf/atcommand_athena.conf
set M_SRV_C4=./conf/script_athena.conf
set M_SRV_C5=./conf/msg_athena.conf
set M_SRV_C6=./conf/grf-files.txt

rem �T�[�r�X���̃T�t�B�b�N�X
rem  �����}�V���ŕ����� Athena �T�[�r�X��o�^����ꍇ�ɁA
rem  �ݒ肷��K�v������܂��B���Ƃ��� 2 �Ȃǂ�ݒ肵�܂��B
set L_SUF=
set C_SUF=
set M_SUF=

rem �W���o�͂̃��O�t�@�C��
rem  �T�[�o�[�Ԃœ����t�@�C���͎w��ł��܂���B
rem  �����}�V���ŕ����̃T�[�r�X�Ȃǂ�o�^����ꍇ�͓��ɒ��ӂ��Ă��������B
set L_OUT=%LOGPATH%login_svc_stdout.log
set C_OUT=%LOGPATH%char_svc_stdout.log
set M_OUT=%LOGPATH%map_svc_stdout.log

rem �W���G���[�o�͂̃��O�t�@�C��
rem  �W���o�͂Ɠ����t�@�C���͎w��ł��܂���B
rem  �W���G���[�ɂ͂قƂ�ǃf�[�^�͏o�͂���Ȃ��̂ŁA���w��ł����܂��܂���B
set L_ERR=
set C_ERR=
set M_ERR=
rem set L_ERR=%LOGPATH%login_svc_stderr.log
rem set C_ERR=%LOGPATH%char_svc_stderr.log
rem set M_ERR=%LOGPATH%map_svc_stderr.log

rem �T�[�r�X�̓o�^
echo �T�[�r�X��o�^���Ă��܂�
%L_SRV% /atnwinsvcinst /suffix=%L_SUF% /stdout=%L_OUT% /stderr=%L_ERR% %L_SRV_C%
%C_SRV% /atnwinsvcinst /suffix=%C_SUF% /stdout=%C_OUT% /stderr=%C_ERR% %C_SRV_C% %C_SRV_C2%
%M_SRV% /atnwinsvcinst /suffix=%M_SUF% /stdout=%M_OUT% /stderr=%M_ERR% %M_SRV_C% %M_SRV_C2% %M_SRV_C3% %M_SRV_C4% %M_SRV_C5% %M_SRV_C6%

echo FAILED ���\������Ă��Ȃ���΃T�[�r�X�̓o�^�ɐ������Ă��܂��B
echo.
echo doc/windows_service.txt �ɂ��������āA
echo �c��̐ݒ���s�������ƂɃT�[�r�X�J�n���Ă��������B

pause
