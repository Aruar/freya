
#if defined(_WIN32) && defined(WIN_SERVICE)

#pragma comment( lib, "advapi32.lib" )
#pragma warning( disable: 4996 )

#include "atnwinsvc.h"
#include "core.h"


#include <winsvc.h>
#include <stdio.h>
#include <io.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <time.h>

#define ATNWINSVC_CMD_ENTRY		"/atnwinsvcentry"
#define ATNWINSVC_CMD_INSTALL		"/atnwinsvcinst"
#define ATNWINSVC_CMD_UNINSTALL	"/atnwinsvcuninst"

#define ATNWINSVC_OPT_SUF_LEN	8
#define ATNWINSVC_OPT_SUF		"/suffix="
#define ATNWINSVC_OPT_OUT_LEN	8
#define ATNWINSVC_OPT_OUT		"/stdout="
#define ATNWINSVC_OPT_ERR_LEN	8
#define ATNWINSVC_OPT_ERR		"/stderr="

static char atnwinsvc_name[128]  = "Athena";
static char atnwinsvc_disp[128]  = "Athena";
static char atnwinsvc_desc[1024] = "provides Ragnarok Online Emulation Service.";

static char atnwinsvc_sout[256]  = "./log/svc_out.log";
static char atnwinsvc_serr[256]  = "";

static SERVICE_STATUS_HANDLE	atnwinsvc_st_handle = NULL;
static SERVICE_STATUS			atnwinsvc_status;

static FILE* atnwinsvc_sout_fp = NULL;
static FILE* atnwinsvc_serr_fp = NULL;

static int atnwinsvc_checkpoint = 0;

int atnwinsvc_install( const char* cmd );
int atnwinsvc_uninstall();
int atnwinsvc_start();

static DWORD WINAPI atnwinsvc_handler( DWORD ctrl, DWORD event_type, LPVOID event_data, LPVOID context );
static void WINAPI atnwinsvc_entry( DWORD argc, char **argv );

int atnwinsvc_argc = 0;
char* atnwinsvc_argv[128];

int main( int, char** argv );

// ==========================================
// �T�[�r�X�̖��O�ݒ�
// ------------------------------------------
void atnwinsvc_setname( const char *name, const char *disp, const char *desc )
{
	strcpy( atnwinsvc_name, name );
	strcpy( atnwinsvc_disp, disp );
	strcpy( atnwinsvc_desc, desc );
}

// ==========================================
// �T�[�r�X�̃��O�t�@�C���ݒ�
// ------------------------------------------
void atnwinsvc_setlogfile( const char *sout, const char *serr )
{
	strcpy( atnwinsvc_sout, sout );
	strcpy( atnwinsvc_serr, serr );
}

// ==========================================
// �T�[�r�X�̃I�v�V�������
// ------------------------------------------
void atnwinsvc_getopt( int argc, char** argv )
{
	int i, dec;
	
	if( argc>120 )
		return;
	
	// �I�v�V�����p�����[�^�̉��
	for( i=2,dec=1; i<argc; i++,dec++ )
	{
		if( memcmp( argv[i], ATNWINSVC_OPT_SUF, ATNWINSVC_OPT_SUF_LEN )==0 )
		{
			if( argv[i][ATNWINSVC_OPT_SUF_LEN] )
			{
				strcat( atnwinsvc_name, "_" );
				strcat( atnwinsvc_name, argv[i] + ATNWINSVC_OPT_SUF_LEN );
				strcat( atnwinsvc_disp, " " );
				strcat( atnwinsvc_disp, argv[i] + ATNWINSVC_OPT_SUF_LEN );
			}
			continue;
		}
		else if( memcmp( argv[i], ATNWINSVC_OPT_OUT, ATNWINSVC_OPT_OUT_LEN )==0 )
		{
			strcpy( atnwinsvc_sout, argv[i] + ATNWINSVC_OPT_OUT_LEN );
			continue;
		}
		else if( memcmp( argv[i], ATNWINSVC_OPT_ERR, ATNWINSVC_OPT_ERR_LEN )==0 )
		{
			strcpy( atnwinsvc_serr, argv[i] + ATNWINSVC_OPT_ERR_LEN );
			continue;
		}
		break;
	}
	atnwinsvc_argc = argc-dec;
	for( i=1; i<atnwinsvc_argc; i++ )
		atnwinsvc_argv[i]=argv[i+dec];
	atnwinsvc_argv[0] = argv[0];
}

// ==========================================
// �T�[�r�X�̃��O�̊J�n
// ------------------------------------------
void atnwinsvc_logstart( FILE *fp )
{
	char timestr[256];

	time_t time_;
	time(&time_);
	strftime(timestr,sizeof(timestr),"%d/%b/%Y:%H:%M:%S",localtime(&time_) );

	fprintf( fp, "----- start log at %s -----\n", timestr );
}

// ==========================================
// �T�[�r�X�̃��O�̃t���b�V��
// ------------------------------------------
void atnwinsvc_logflush()
{
	if( atnwinsvc_sout_fp )
		fflush( atnwinsvc_sout_fp );
	if( atnwinsvc_serr_fp )
		fflush( atnwinsvc_serr_fp );
}

// ==========================================
// �T�[�r�X�� core::main ����Ă΂�鏈��
// ------------------------------------------
int atnwinsvc_main( int argc, char **argv )
{
	if( argc<2 || argc>120 )
		return 0;

	if( strcmp( argv[1], ATNWINSVC_CMD_INSTALL )==0 )
	{
		// �C���X�g�[��
		
		char cmd[2048]="";
		int i=0;
		if( argc>2 )
		{
			strcpy( cmd, argv[2] );
			for( i=3; i<argc; i++ )
			{
				strcat( cmd, " " );
				strcat( cmd, argv[i] );
			}
		}
		
		atnwinsvc_getopt( argc, argv );
		if( atnwinsvc_install(cmd) )
		{
			printf("atnwinsvc: service [%s] installed.\n", atnwinsvc_disp );
		}
		else
		{
			printf("atnwinsvc: FAILED: install service.\n", atnwinsvc_disp );
		}
		return 1;
	}
	else if( strcmp( argv[1], ATNWINSVC_CMD_UNINSTALL )==0 )
	{
		// �A���C���X�g�[��
		
		atnwinsvc_getopt( argc, argv );
		if( atnwinsvc_uninstall() )
		{
			printf("atnwinsvc: service [%s] uninstalled.\n", atnwinsvc_disp );
		}
		else
		{
			printf("atnwinsvc: FAILED: uninstall service.\n", atnwinsvc_disp );
		}
		return 1;
	}
	else if( strcmp( argv[1], ATNWINSVC_CMD_ENTRY )==0 )
	{
		// ���C������
		
		atnwinsvc_getopt( argc, argv );
		if( !atnwinsvc_start() )
		{
			printf("atnwinsvc: FAILED: start service.\n");
		}
		return 1;
	}
	
	// �T�[�r�X�����ł͂Ȃ�
	return 0;
}


// ==========================================
// �T�[�r�X�̏�ԕύX
// ------------------------------------------
int atnwinsvc_change_status()
{
	return SetServiceStatus( atnwinsvc_st_handle, &atnwinsvc_status ) != 0;
}

// ==========================================
// �T�[�r�X�̃C���X�g�[��
// ------------------------------------------
static int atnwinsvc_install( const char *cmd )
{
	char path[MAX_PATH + 2048 ];
	SC_HANDLE scm;
	SC_HANDLE svc;

	if( !GetModuleFileName( 0, path, MAX_PATH ) )
		return 0;

	strcat( path, " " ATNWINSVC_CMD_ENTRY );
	if( cmd && cmd[0] )
	{
		strcat( path, " " );
		strcat( path, cmd );
	}

	if( !(scm = OpenSCManager( NULL, NULL, SC_MANAGER_ALL_ACCESS ) ) )
		return 0;
	
	svc = CreateService( scm, atnwinsvc_name, atnwinsvc_disp, SERVICE_ALL_ACCESS,
						SERVICE_WIN32_OWN_PROCESS,	SERVICE_DEMAND_START,
						SERVICE_ERROR_NORMAL,		path,
						NULL, NULL, NULL, NULL, NULL );

	if( !svc )
	{
		CloseServiceHandle( scm );
		return 0;
	}

	if( atnwinsvc_desc && atnwinsvc_desc[0] )
	{
		// �����o�^
		SERVICE_DESCRIPTION svcdesc;
		ZeroMemory( &svcdesc, sizeof( svcdesc ) );
		svcdesc.lpDescription = atnwinsvc_desc;
		ChangeServiceConfig2( svc, SERVICE_CONFIG_DESCRIPTION, &svcdesc );
	}

	CloseServiceHandle( svc );
	CloseServiceHandle( scm );
	return 1;

}

// ==========================================
// �T�[�r�X�̃A���C���X�g�[��
// ------------------------------------------
static int atnwinsvc_uninstall()
{
	char path[MAX_PATH];
	SC_HANDLE scm;
	SC_HANDLE svc;
	int ret = 0;
	
	if( !GetModuleFileName( 0, path, MAX_PATH ) )
		return 0;
	
	if( !(scm = OpenSCManager( NULL, NULL, SC_MANAGER_ALL_ACCESS ) ) )
		return 0;
	
	if( !( svc = OpenService( scm, atnwinsvc_name, DELETE ) ) )
	{
		CloseServiceHandle( scm );
		return 0;
	}

	if( DeleteService( svc ) )
		ret = 1;

	CloseServiceHandle( svc );
	CloseServiceHandle( scm );
	return ret;
}

// ==========================================
// �T�[�r�X�̏����J�n
// ------------------------------------------
static int atnwinsvc_start()
{
	SERVICE_TABLE_ENTRY svctable[2];
	ZeroMemory( svctable, sizeof( svctable ) );
	svctable[0].lpServiceName = atnwinsvc_name;
	svctable[0].lpServiceProc = atnwinsvc_entry;

	// �T�[�r�X�R���g���[���f�B�X�p�b�`���N��
	if( !StartServiceCtrlDispatcher( svctable ) )
	{
		return 0;
	}

	return 1;
}

// ==========================================
// �T�[�r�X�̏I������
// ------------------------------------------
void atnwinsvc_final(void)
{
	if( atnwinsvc_sout_fp )
		fclose( atnwinsvc_sout_fp );
	if( atnwinsvc_serr_fp )
		fclose( atnwinsvc_serr_fp );
		
	atnwinsvc_notify_finish();
}
 
// ==========================================
// �T�[�r�X�̃��C������
// ------------------------------------------
static void WINAPI atnwinsvc_entry( DWORD argc, char **argv )
{

	// �n���h���o�^
	atnwinsvc_st_handle =
		RegisterServiceCtrlHandlerEx( atnwinsvc_name, atnwinsvc_handler, NULL );
		
	if( !atnwinsvc_st_handle )
		return;

	// ��ԍ\���̂̏�����
	atnwinsvc_checkpoint = 0;
	atnwinsvc_status.dwServiceType = SERVICE_WIN32_OWN_PROCESS;
	atnwinsvc_status.dwCurrentState = SERVICE_START_PENDING;
	atnwinsvc_status.dwWin32ExitCode = NO_ERROR;
	atnwinsvc_status.dwServiceSpecificExitCode = NO_ERROR;
	atnwinsvc_status.dwCheckPoint = (atnwinsvc_checkpoint++);
	atnwinsvc_status.dwWaitHint = 0;
	atnwinsvc_status.dwControlsAccepted = 
		SERVICE_ACCEPT_STOP | SERVICE_ACCEPT_SHUTDOWN/* | SERVICE_ACCEPT_PAUSE_CONTINUE*/;

	// �����J�n��ʒm
	atnwinsvc_change_status();
	
	
	// �J�����g�f�B���N�g���ύX
	{
		int i, j=0;
		char path[MAX_PATH];
		
		if( !GetModuleFileName( 0, path, MAX_PATH ) )
		{
			atnwinsvc_notify_finish();
			return;
		}
		for( i=0; path[i]; i++ )
		{
			if( path[i]=='/' || path[i]=='\\' )
				j=i;
		}
		path[j]='\0';
		
		// bin �f�B���N�g������菜��
		if( j>4 && (stricmp(path+j-4,"\\bin")==0 || stricmp(path+j-4,"/bin")==0) )
			path[j-4]='\0';
		
		SetCurrentDirectory( path );
	}
	
	
	
	// �W���o��/�G���[�����_�C���N�g
	{
		atnwinsvc_sout_fp = freopen( atnwinsvc_sout, "ac", stdout );
		atnwinsvc_logstart( atnwinsvc_sout_fp );
		
		if( atnwinsvc_serr[0] )
		{
			atnwinsvc_serr_fp = freopen( atnwinsvc_serr, "ac", stderr );
			atnwinsvc_logstart( atnwinsvc_serr_fp );
		}
	}
	
	// ���C�������J�n
	atexit( atnwinsvc_final );
	if( argc>1 )
		main( argc, argv );		// �T�[�r�X�N�����Ƀp�����[�^���w�肳�ꂽ
	else
		main( atnwinsvc_argc, atnwinsvc_argv );	// �T�[�r�X�o�^���̃p�����[�^���g��
	
}

// ==========================================
// �T�[�r�X�̃n���h��
// ------------------------------------------
static DWORD WINAPI atnwinsvc_handler( DWORD ctrl, DWORD event_type, LPVOID event_data, LPVOID context )
{
	DWORD ret;
	switch( ctrl )
	{
	case SERVICE_CONTROL_INTERROGATE:	// ���
		ret = NO_ERROR;
		break;

	case SERVICE_CONTROL_STOP:			// ��~
	case SERVICE_CONTROL_SHUTDOWN:		// �V���b�g�_�E��
		atnwinsvc_notify_stop();
		core_stop();
		break;
	}
	atnwinsvc_change_status();
	return ret;
}


// ==========================================
// �T�[�r�X�̊J�n���ʒm
// ------------------------------------------
int atnwinsvc_notify_start()
{
	if( atnwinsvc_st_handle )
	{
		atnwinsvc_status.dwCurrentState = SERVICE_START_PENDING;
		atnwinsvc_status.dwCheckPoint = (atnwinsvc_checkpoint++);
//		atnwinsvc_status.dwWaitHint = 0;
		return atnwinsvc_change_status();
	}
	return -1;
}

// ==========================================
// �T�[�r�X�̏��������ʒm
// ------------------------------------------
int atnwinsvc_notify_ready()
{
	if( atnwinsvc_st_handle )
	{
		atnwinsvc_checkpoint = 0;
		atnwinsvc_status.dwCurrentState = SERVICE_RUNNING;
		atnwinsvc_status.dwCheckPoint = 0;
		atnwinsvc_status.dwWaitHint = 0;
		return atnwinsvc_change_status();
	}
	return -1;
}


// ==========================================
// �T�[�r�X�̒�~���ʒm
// ------------------------------------------
int atnwinsvc_notify_stop()
{
	if( atnwinsvc_st_handle )
	{
		atnwinsvc_status.dwCurrentState = SERVICE_STOP_PENDING;
		atnwinsvc_status.dwCheckPoint = (atnwinsvc_checkpoint++);
//		atnwinsvc_status.dwWaitHint = 0;
		return atnwinsvc_change_status();
	}
	return -1;
}


// ==========================================
// �T�[�r�X�̏��������ʒm
// ------------------------------------------
int atnwinsvc_notify_finish()
{
	if( atnwinsvc_st_handle )
	{
		atnwinsvc_checkpoint = 0;
		atnwinsvc_status.dwCurrentState = SERVICE_STOPPED;
		atnwinsvc_status.dwCheckPoint = 0;
		atnwinsvc_status.dwWaitHint = 0;
//		atnwinsvc_status.dwWin32ExitCode = 0;
		return atnwinsvc_change_status();
	}
	return -1;
}


#endif
