: ��������� ����������! �� ��������!
@echo off

Del t3dlogo.t3d

copy %1 t3dlogo.t3d
If errorlevel 1 exit
t3dbrowser

: �������� �� �����...
Del t3dlogo.t3d