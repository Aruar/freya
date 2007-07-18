@echo off
rem VC++ 6.0 / VC++ .net / VC++ .net 2003 / VC++ .net 2005 / VC++ ToolKit 2003 
rem �r���h�p�o�b�`�t�@�C��

rem ---------------------------
rem �p�X�̐ݒ�

rem VC++ Toolkit
Set PATH=C:\Program Files\Microsoft Visual C++ Toolkit 2003\bin;C:\Program Files\Microsoft Platform SDK\Bin;C:\Program Files\Microsoft Platform SDK\Bin\winnt;C:\Program Files\Microsoft Platform SDK\Bin\Win64;%PATH%
Set INCLUDE=C:\Program Files\Microsoft Visual C++ Toolkit 2003\include;C:\Program Files\Microsoft Platform SDK\include;%INCLUDE%
Set LIB=C:\Program Files\Microsoft Visual C++ Toolkit 2003\lib;C:\Program Files\Microsoft Platform SDK\Lib;%LIB%

rem VC++ .net 2005
rem Set PATH=C:\Program Files\Microsoft Visual Studio 8\VC\bin;C:\Program Files\Microsoft Platform SDK\Bin;C:\Program Files\Microsoft Platform SDK\Bin\winnt;C:\Program Files\Microsoft Platform SDK\Bin\Win64;%PATH%
rem Set INCLUDE=C:\Program Files\Microsoft Visual Studio 8\VC\include;C:\Program Files\Microsoft Platform SDK\include;%INCLUDE%
rem Set LIB=C:\Program Files\Microsoft Visual Studio 8\VC\lib;C:\Program Files\Microsoft Platform SDK\Lib;%LIB%

rem VC++ .net 2005 / �K�v�Ȃ�R�����g�A�E�g���͂���
rem call "C:\Program Files\Microsoft Visual Studio 8\VC\bin\VCVARS32.BAT"

rem VC++ .net 2003 / �K�v�Ȃ�R�����g�A�E�g���͂���
rem call "C:\Program Files\Microsoft Visual Studio .NET 2003\Vc7\bin\vcvars32.bat"

rem VC++ .net (2002) / �K�v�Ȃ�R�����g�A�E�g���͂���
rem call "C:\Program Files\Microsoft Visual Studio .NET\Vc7\bin\vcvars32.bat"

rem VC++ 6.0 / �K�v�Ȃ�R�����g�A�E�g���͂���
rem �����ȊO�� __opt2__ �� /MAP �� /nologo �������K�v������
rem call "C:\Program Files\Microsoft Visual Studio\VC98\Bin\vcvars32.bat"


rem MySQL��Include��libmysql.lib�̕ۑ��ꏊ�@�����ɏ��������鎖
rem SQL�łɂ���ꍇ���L�Q�s�̃R�����g�A�E�g���͂����ĉ������B
rem set __sqlinclude__=-I../sql/include/
rem set __sqllib__=../sql/vclib/libmysql.lib

rem -------------------------------------------------------------
rem �r���h�I�v�V�����̑I��

rem txt/sql �I�� �F sql �ɂ���Ȃ�R�����g�A�E�g����
set __TXT_MODE__=/D "TXT_ONLY"

rem txt �ŁA�W���[�i�����g���Ȃ�R�����g�A�E�g���͂���
rem set __TXT_MODE__=/D "TXT_ONLY" /D "TXT_JOURNAL"

rem login_id2 �� IP �ł��ɂ傲�ɂ債�����l�̓R�����g�A�E�g���͂���
rem set __CMP_AFL2__=/D "CMP_AUTHFIFO_LOGIN2"
rem set __CMP_AFIP__=/D "CMP_AUTHFIFO_IP"

rem httpd �����S�ɖ����ɂ���ꍇ�R�����g�A�E�g���͂���
rem set __NO_HTTPD__=/D "NO_HTTPD"

rem httpd �ŊO�� CGI ���g���ꍇ�̓R�����g�A�E�g����
set __NO_HTTPD_CGI__=/D "NO_HTTPD_CGI"

rem csvdb �����S�ɖ����ɂ���ꍇ�R�����g�A�E�g���͂���
rem set __NO_CSVDB__=/D "NO_CSVDB"

rem csvdb �̃X�N���v�g����̗��p�𖳌��ɂ���ꍇ�R�����g�A�E�g���͂���
rem set __NO_CSVDB_SCRIPT__=/D "NO_CSVDB_SCRIPT"

rem TK SG SL �ł��ɂ傲�ɂ債�����l�̓R�����g�A�E�g���͂���
rem set __EXCLASS__=/D "TKSGSL"
rem set __EXCLASS__=/D "TKSGSLGSNJ"

rem ���I��MOB��sc_data���m�ۂ������l�̓R�����g�A�E�g���͂���
rem set __DYNAMIC_STATUS_CHANGE__=/D "DYNAMIC_SC_DATA"

rem account regist MailAddress
rem set __AC_MAIL__=/D "AC_MAIL"

rem ---------------------------
rem �R���p�C���I�v�V�����ݒ�

@rem CPU�œK���X�C�b�`(By Nameless)
@rem �ȉ��̗���Q�l�ɃX�C�b�`�����L�����Ă��������B
set _model_=x32

@rem CPU�A�[�L�e�N�`��32BitCPU/64BitCPU
if "%_model_%"=="x32" set __cpu__=/c /W3 /O2 /Op /GA /TC /Zi
if "%_model_%"=="x64" set __cpu__=/c /arch:SSE2 /W3 /O2 /Op /GA /TC /Zi

@rem �������[1024�ȏ㓋�ڂ�32bitCPU/64bitCPU
if "%_model_%"=="HiMemL" set __cpu__=/c /bigobj /W3 /O2 /Op /GA /TC /Zi
if "%_model_%"=="HiMemH" set __cpu__=/c /bigobj /arch:SSE2 /W3 /O2 /Op /GA /TC /Zi

@rem �X�^�b�N������R���p�C���ōs���ꍇ
if "%_model_%"=="Stac32" set __cpu__=/c /F4096 /W3 /O2 /Op /GA /TC /Zi
if "%_model_%"=="Stac64" set __cpu__=/c /F4096 /arch:SSE2 /W3 /O2 /Op /GA /TC /Zi
@rem AMD�n64bitCPU�p
if "%_model_%"=="A64x2" set __cpu__=/c /favor:blend /W3 /O2 /Op /GA /TC /Zi
if "%_model_%"=="A64x1" set __cpu__=/c /favor:AMD64 /W3 /O2 /Op /GA /TC /Zi

@rem Intel�n64bitCPU�p
if "%_model_%"=="EM64T" set __cpu__=/c /favor:EM64T /W3 /O2 /Op /GA /TC /Zi

@rem �ȉ������i�K(�l������ by Nameless)
@rem �\�������c32BitCPU�ō������[�h
if "%_model_%"=="mode01" set __cpu__=/c /fp:fast /F4096 /bigobj /W3 /Ox /GA /TC /Zi
@rem �\�������c64BitCPU�ō������[�h
if "%_model_%"=="mode02" set __cpu__=/c /arch:SSE2 /fp:fast /F4096 /bigobj /W3 /Ox /Gr /GA /TC /Zi
@rem �\�������cAMD 64x2 & FX�n�œK���E�ō���
if "%_model_%"=="mode03" set __cpu__=/c /arch:SSE2 /fp:fast /F4096 /bigobj /favor:AMD64 /W3 /Ox /Gr /GA /TC /Zi
if "%_model_%"=="mode04" set __cpu__=/c /arch:SSE2 /fp:fast /F4096 /bigobj /favor:blend /W3 /Ox /Gr /GA /TC /Zi
@rem �\�������cIntel 64bitCPU�p�œK���E�ō���
if "%_model_%"=="mode05" set __cpu__=/c /arch:SSE2 /fp:fast /F4096 /bigobj /favor:EM64T /W3 /Ox /Gr /GA /TC /Zi
@rem �ȉ����U�[�u
if "%_model_%"=="mode06" set __cpu__=/c /W3 /Ox /Gr /GA /TC /Zi
if "%_model_%"=="mode07" set __cpu__=/c /W3 /Ox /Gr /GA /TC /Zi
if "%_model_%"=="mode08" set __cpu__=/c /W3 /Ox /Gr /GA /TC /Zi
if "%_model_%"=="mode09" set __cpu__=/c /W3 /Ox /Gr /GA /TC /Zi

set __opt1__=/I "../common/zlib/" /I "../common/" /D "PACKETVER=7" /D "NEW_006b" /D "FD_SETSIZE=4096"  /D "LOCALZLIB" /D "NDEBUG" /D "_CONSOLE" /D "WIN32" /D "_WIN32" /D "_WIN32_WINDOWS" /D "_CRT_SECURE_NO_DEPRECATE" %__TXT_MODE__% %__CMP_AFL2__% %__CMP_AFIP__% %__NO_HTTPD__% %__NO_HTTPD_CGI__% %__NO_CSVDB__% %__NO_CSVDB_SCRIPT__% %__EXCLASS__% %__DYNAMIC_STATUS_CHANGE__% %__AC_MAIL__%

set __opt2__=/DEBUG /MAP /nologo user32.lib ../common/zlib/*.obj ../common/*.obj *.obj

rem ---------------------------
rem �R���p�C��
@echo zlib�R���p�C��
cd src\common\zlib
cl %__cpu__% %__opt1__% *.c
cd ..\
cl %__cpu__% %__opt1__% *.c 

@echo ���O�C���T�[�o�[�R���p�C��
cd ..\login
cl %__cpu__% %__opt1__% %__sqlinclude__% *.c
link %__opt2__% %__sqllib__% /out:"../../bin/login-server.exe"

@echo �L�����N�^�[�T�[�o�[�R���p�C��
cd ..\char
cl %__cpu__% %__opt1__% %__sqlinclude__% *.c
link %__opt2__% %__sqllib__% /out:"../../bin/char-server.exe"

@echo �}�b�v�T�[�o�[�R���p�C��
cd ..\map
cl %__cpu__% %__opt1__% *.c
link %__opt2__% /out:"../../bin/map-server.exe"

@echo �R���o�[�^�[�R���p�C��
cd ..\converter
cl %__cpu__% %__opt1__% %__sqlinclude__% *.c
link %__opt2__% %__sqllib__% /out:"../../bin/txt-converter.exe"

cd ..\..\

@echo �I�u�W�F�N�g�t�@�C�����̃N���[���A�b�v
del src\common\zlib\*.obj
del src\common\*.obj
del src\char\*.obj
del src\login\*.obj
del src\map\*.obj
del src\converter\*.obj

pause