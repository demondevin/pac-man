;=#
; 
; PORTABLEAPPS COMPILER 
; Developed by daemon.devin (daemon.devin@gmail.com)
;
; For support, visit the GitHub project:
; https://github.com/daemondevin/pac-man
; 
; SEGMENT
;   Environment.nsh
;   This file handles the environment variables which are configured in the Launcher.ini file.
; 

${SegmentFile}
${SegmentInit}
	!ifmacrodef Variables
		!insertmacro Variables
	!endif
!macroend
${SegmentPre}
	${ForEachINIPair} Environment $0 $1
		ExpandEnvStrings $1 $1
		System::Call `Kernel32::SetEnvironmentVariable(tr0,tr1)`
	${NextINIPair}
!macroend
