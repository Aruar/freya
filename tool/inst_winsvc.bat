@echo off

rem ��¼Athena��־���ļ���
set LOGPATH=./log/

rem �����·��
set L_SRV=login-server
set C_SRV=char-server
set M_SRV=map-server

rem conf�ļ��趨
set L_SRV_C=./conf/login_athena.conf
set C_SRV_C=./conf/char_athena.conf
set C_SRV_C2=./conf/inter_athena.conf
set M_SRV_C=./conf/map_athena.conf
set M_SRV_C2=./conf/battle_athena.conf
set M_SRV_C3=./conf/atcommand_athena.conf
set M_SRV_C4=./conf/script_athena.conf
set M_SRV_C5=./conf/msg_athena.conf
set M_SRV_C6=./conf/grf-files.txt

rem ע��ķ�����
rem ��һ̨�����Ͽ�2�������ϵ�Athenaʱ���趨��
set L_SUF=
set C_SUF=
set M_SUF=

rem ������������־·��
rem �ڷ������������֮�䲻����ָ��ͬ�����ļ�����
rem �����һ̨���������Athenaʱ���ر�Ҫע�⡣
set L_OUT=%LOGPATH%login_svc_stdout.log
set C_OUT=%LOGPATH%char_svc_stdout.log
set M_OUT=%LOGPATH%map_svc_stdout.log

rem ������������־·��
rem ����ָ���볣����־��ͬ���ļ�����
rem ���ڴ�����־��˵������û����������Բ�ָ��Ҳ����ν��
set L_ERR=
set C_ERR=
set M_ERR=
rem set L_ERR=%LOGPATH%login_svc_stderr.log
rem set C_ERR=%LOGPATH%char_svc_stderr.log
rem set M_ERR=%LOGPATH%map_svc_stderr.log

rem ��װ����
echo ��װ����
%L_SRV% /atnwinsvcinst /suffix=%L_SUF% /stdout=%L_OUT% /stderr=%L_ERR% %L_SRV_C%
%C_SRV% /atnwinsvcinst /suffix=%C_SUF% /stdout=%C_OUT% /stderr=%C_ERR% %C_SRV_C% %C_SRV_C2%
%M_SRV% /atnwinsvcinst /suffix=%M_SUF% /stdout=%M_OUT% /stderr=%M_ERR% %M_SRV_C% %M_SRV_C2% %M_SRV_C3% %M_SRV_C4% %M_SRV_C5% %M_SRV_C6%

echo ���û����ʾ FAILED �Ļ�����ʾ��װ����ɹ���
echo.
echo ����doc/windows_service.txt��
echo ���к����µ��趨�󣬾��������������ɡ�

pause
