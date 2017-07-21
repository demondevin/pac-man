!macro !defineifexist _VAR_NAME _FILE_NAME
	!tempfile _TEMPFILE
	!ifdef NSIS_WIN32_MAKENSIS
		!system 'if exist "${_FILE_NAME}" echo !define ${_VAR_NAME} > "${_TEMPFILE}"'
	!else
		!system 'if [ -e "${_FILE_NAME}" ]; then echo "!define ${_VAR_NAME}" > "${_TEMPFILE}"; fi'
	!endif
	!include '${_TEMPFILE}'
	!delfile '${_TEMPFILE}'
	!undef _TEMPFILE
!macroend
!define !defineifexist "!insertmacro !defineifexist"
!define Init::File "!insertmacro _Init::File"
!macro _Init::File _DIR _FILE
	StrCmpS `${_FILE}` "" 0 +4
	IfFileExists `${DATA}\${_DIR}` +10
	CreateDirectory `${DATA}\${_DIR}`
	Goto +8
	StrCmpS `${_DIR}` "" 0 +4
	IfFileExists `${DATA}\${_FILE}` +6
	CopyFiles /SILENT `${DEFDATA}\${_FILE}` `${DATA}`
	Goto +4
	IfFileExists `${DATA}\${_DIR}\${_FILE}` +3
	CreateDirectory `${DATA}\${_DIR}`
	CopyFiles /SILENT `${DEFDATA}\${_DIR}\${_FILE}` `${DATA}\${_DIR}`
!macroend
${SegmentFile}
${SegmentInit}
	!ifmacrodef Init
		!insertmacro Init
	!endif
	; Check for settings
	${IfNot} ${FileExists} $EXEDIR\Data\settings
		${DebugMsg} "$EXEDIR\Data\settings does not exist. Creating it."
		CreateDirectory $EXEDIR\Data\settings
		${If} ${FileExists} $EXEDIR\App\DefaultData\*.*
			${DebugMsg} "Copying default data from $EXEDIR\App\DefaultData to $EXEDIR\Data."
			CopyFiles /SILENT $EXEDIR\App\DefaultData\*.* $EXEDIR\Data
		${EndIf}
	${EndIf}
	!ifmacrodef UnInit
		!insertmacro UnInit
	!endif
!macroend
