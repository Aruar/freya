@echo off

rem �����·��
set L_SRV=login-server
set C_SRV=char-server
set M_SRV=map-server

rem ע��ķ�����
rem ��һ̨�����Ͽ�2�������ϵ�Athenaʱ���趨��
set L_SUF=
set C_SUF=
set M_SUF=

rem ж�ط���
echo ж�ط���
%L_SRV% /atnwinsvcuninst /suffix=%L_SUF%
%C_SRV% /atnwinsvcuninst /suffix=%C_SUF%
%M_SRV% /atnwinsvcuninst /suffix=%M_SUF%

echo ���û����ʾ FAILED �Ļ�����ʾж�ط���ɹ���

pause
