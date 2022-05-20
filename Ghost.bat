REM Ghost文件请放在 FirPE\Ghost 目录下
@echo off
REM Ghost文件名,请勿带空格和中文!
set NAME=Ghost.gho
REM Ghost文件恢复页,如无修改请勿乱动
set PAGE=1
REM Ghost程序所在位置
set GHOST="X:\Program Files (x86)\备份还原\ghost64.exe"

::-----------------------------------
::-          作者: 577fkj           -
::-----------------------------------

rem 如不为 WinPE 则直接退出
if not exist X: goto :eof

REM 查找pe分区
for %%U in (Z Y X W V U T S R Q P O N M L K J I H G F E D C ) do if exist %%U:\FirPE\Ghost (
	set usbDisk=%%U
)
REM 查找Windows分区
for %%U in (Z Y X W V U T S R Q P O N M L K J I H G F E D C ) do if exist %%U:\Windows\hh.exe (
	set WindowsDisk=%%U
)

if not exist %usbDisk%:\FirPE\Ghost\%NAME%:%PAGE% echo 文件不存在 && pause && goto :eof

echo 开始执行恢复
call:GetDiskID %WindowsDisk%
start %GHOST% -clone,mode=pload,src=%usbDisk%:\FirPE\Ghost\%NAME%:%PAGE%,dst=%retVal% -sure -rb
pause

:GetDiskID
setlocal ENABLEDELAYEDEXPANSION
set _label_=%~1
for /f "usebackq tokens=2 delims==" %%a in (`
    wmic logicaldisk where ^(DeviceID^='%_label_%'^) get name /value
`) do (
    if not defined _letter_ (set _letter_=%%a)
)
for /f "usebackq tokens=3 delims==" %%a in (`
    wmic path Win32_LogicalDiskToPartition.Dependent^='Win32_LogicalDisk.DeviceID^="%_letter_%"' get Antecedent /value
`) do (
    set _dp_=%%a
    set _dp_=!_dp_:"=%!
)
set _dp_=!_dp_:Disk=%!
set _dp_=!_dp_: =%!
set _dp_=!_dp_:#=%!
set _dp_=!_dp_:Partition=%!
set _dp_=!_dp_:,=:%!
set retVal=%_dp_%
