@echo off

rem Athena �̃p�X��ݒ肷��iReadme ������t�H���_�j
set ATHENAPATH=..\..\

rem ���s�t�@�C��������t�H���_
set BINPATH=%ATHENAPATH%
rem set BINPATH=%ATHENAPATH%bin\

rem ���s�t�@�C��
set L_SRV=%BINPATH%login-server
set C_SRV=%BINPATH%char-server
set M_SRV=%BINPATH%map-server

rem �T�[�r�X���̃T�t�B�b�N�X
rem  �����}�V���ŕ����� Athena �T�[�r�X��o�^����ꍇ�ɁA
rem  �ݒ肷��K�v������܂��B���Ƃ��� 2 �Ȃǂ�ݒ肵�܂��B
set L_SUF=
set C_SUF=
set M_SUF=

rem �T�[�r�X�̍폜
echo �T�[�r�X���폜���Ă��܂�
%L_SRV% /atnwinsvcuninst /suffix=%L_SUF%
%C_SRV% /atnwinsvcuninst /suffix=%C_SUF%
%M_SRV% /atnwinsvcuninst /suffix=%M_SUF%

echo FAILED ���\������Ă��Ȃ���΃T�[�r�X�̍폜�ɐ������Ă��܂��B

pause
