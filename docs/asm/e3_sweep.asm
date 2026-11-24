
bin/e3_sweep:     file format elf64-x86-64


Disassembly of section .init:

0000000000001000 <_init>:
    1000:	f3 0f 1e fa          	endbr64
    1004:	48 83 ec 08          	sub    rsp,0x8
    1008:	48 8b 05 d9 3f 00 00 	mov    rax,QWORD PTR [rip+0x3fd9]        # 4fe8 <__gmon_start__@Base>
    100f:	48 85 c0             	test   rax,rax
    1012:	74 02                	je     1016 <_init+0x16>
    1014:	ff d0                	call   rax
    1016:	48 83 c4 08          	add    rsp,0x8
    101a:	c3                   	ret

Disassembly of section .plt:

0000000000001020 <.plt>:
    1020:	ff 35 c2 3e 00 00    	push   QWORD PTR [rip+0x3ec2]        # 4ee8 <_GLOBAL_OFFSET_TABLE_+0x8>
    1026:	f2 ff 25 c3 3e 00 00 	bnd jmp QWORD PTR [rip+0x3ec3]        # 4ef0 <_GLOBAL_OFFSET_TABLE_+0x10>
    102d:	0f 1f 00             	nop    DWORD PTR [rax]
    1030:	f3 0f 1e fa          	endbr64
    1034:	68 00 00 00 00       	push   0x0
    1039:	f2 e9 e1 ff ff ff    	bnd jmp 1020 <_init+0x20>
    103f:	90                   	nop
    1040:	f3 0f 1e fa          	endbr64
    1044:	68 01 00 00 00       	push   0x1
    1049:	f2 e9 d1 ff ff ff    	bnd jmp 1020 <_init+0x20>
    104f:	90                   	nop
    1050:	f3 0f 1e fa          	endbr64
    1054:	68 02 00 00 00       	push   0x2
    1059:	f2 e9 c1 ff ff ff    	bnd jmp 1020 <_init+0x20>
    105f:	90                   	nop
    1060:	f3 0f 1e fa          	endbr64
    1064:	68 03 00 00 00       	push   0x3
    1069:	f2 e9 b1 ff ff ff    	bnd jmp 1020 <_init+0x20>
    106f:	90                   	nop
    1070:	f3 0f 1e fa          	endbr64
    1074:	68 04 00 00 00       	push   0x4
    1079:	f2 e9 a1 ff ff ff    	bnd jmp 1020 <_init+0x20>
    107f:	90                   	nop
    1080:	f3 0f 1e fa          	endbr64
    1084:	68 05 00 00 00       	push   0x5
    1089:	f2 e9 91 ff ff ff    	bnd jmp 1020 <_init+0x20>
    108f:	90                   	nop
    1090:	f3 0f 1e fa          	endbr64
    1094:	68 06 00 00 00       	push   0x6
    1099:	f2 e9 81 ff ff ff    	bnd jmp 1020 <_init+0x20>
    109f:	90                   	nop
    10a0:	f3 0f 1e fa          	endbr64
    10a4:	68 07 00 00 00       	push   0x7
    10a9:	f2 e9 71 ff ff ff    	bnd jmp 1020 <_init+0x20>
    10af:	90                   	nop
    10b0:	f3 0f 1e fa          	endbr64
    10b4:	68 08 00 00 00       	push   0x8
    10b9:	f2 e9 61 ff ff ff    	bnd jmp 1020 <_init+0x20>
    10bf:	90                   	nop
    10c0:	f3 0f 1e fa          	endbr64
    10c4:	68 09 00 00 00       	push   0x9
    10c9:	f2 e9 51 ff ff ff    	bnd jmp 1020 <_init+0x20>
    10cf:	90                   	nop
    10d0:	f3 0f 1e fa          	endbr64
    10d4:	68 0a 00 00 00       	push   0xa
    10d9:	f2 e9 41 ff ff ff    	bnd jmp 1020 <_init+0x20>
    10df:	90                   	nop
    10e0:	f3 0f 1e fa          	endbr64
    10e4:	68 0b 00 00 00       	push   0xb
    10e9:	f2 e9 31 ff ff ff    	bnd jmp 1020 <_init+0x20>
    10ef:	90                   	nop
    10f0:	f3 0f 1e fa          	endbr64
    10f4:	68 0c 00 00 00       	push   0xc
    10f9:	f2 e9 21 ff ff ff    	bnd jmp 1020 <_init+0x20>
    10ff:	90                   	nop
    1100:	f3 0f 1e fa          	endbr64
    1104:	68 0d 00 00 00       	push   0xd
    1109:	f2 e9 11 ff ff ff    	bnd jmp 1020 <_init+0x20>
    110f:	90                   	nop
    1110:	f3 0f 1e fa          	endbr64
    1114:	68 0e 00 00 00       	push   0xe
    1119:	f2 e9 01 ff ff ff    	bnd jmp 1020 <_init+0x20>
    111f:	90                   	nop
    1120:	f3 0f 1e fa          	endbr64
    1124:	68 0f 00 00 00       	push   0xf
    1129:	f2 e9 f1 fe ff ff    	bnd jmp 1020 <_init+0x20>
    112f:	90                   	nop
    1130:	f3 0f 1e fa          	endbr64
    1134:	68 10 00 00 00       	push   0x10
    1139:	f2 e9 e1 fe ff ff    	bnd jmp 1020 <_init+0x20>
    113f:	90                   	nop
    1140:	f3 0f 1e fa          	endbr64
    1144:	68 11 00 00 00       	push   0x11
    1149:	f2 e9 d1 fe ff ff    	bnd jmp 1020 <_init+0x20>
    114f:	90                   	nop
    1150:	f3 0f 1e fa          	endbr64
    1154:	68 12 00 00 00       	push   0x12
    1159:	f2 e9 c1 fe ff ff    	bnd jmp 1020 <_init+0x20>
    115f:	90                   	nop
    1160:	f3 0f 1e fa          	endbr64
    1164:	68 13 00 00 00       	push   0x13
    1169:	f2 e9 b1 fe ff ff    	bnd jmp 1020 <_init+0x20>
    116f:	90                   	nop
    1170:	f3 0f 1e fa          	endbr64
    1174:	68 14 00 00 00       	push   0x14
    1179:	f2 e9 a1 fe ff ff    	bnd jmp 1020 <_init+0x20>
    117f:	90                   	nop
    1180:	f3 0f 1e fa          	endbr64
    1184:	68 15 00 00 00       	push   0x15
    1189:	f2 e9 91 fe ff ff    	bnd jmp 1020 <_init+0x20>
    118f:	90                   	nop
    1190:	f3 0f 1e fa          	endbr64
    1194:	68 16 00 00 00       	push   0x16
    1199:	f2 e9 81 fe ff ff    	bnd jmp 1020 <_init+0x20>
    119f:	90                   	nop
    11a0:	f3 0f 1e fa          	endbr64
    11a4:	68 17 00 00 00       	push   0x17
    11a9:	f2 e9 71 fe ff ff    	bnd jmp 1020 <_init+0x20>
    11af:	90                   	nop
    11b0:	f3 0f 1e fa          	endbr64
    11b4:	68 18 00 00 00       	push   0x18
    11b9:	f2 e9 61 fe ff ff    	bnd jmp 1020 <_init+0x20>
    11bf:	90                   	nop
    11c0:	f3 0f 1e fa          	endbr64
    11c4:	68 19 00 00 00       	push   0x19
    11c9:	f2 e9 51 fe ff ff    	bnd jmp 1020 <_init+0x20>
    11cf:	90                   	nop
    11d0:	f3 0f 1e fa          	endbr64
    11d4:	68 1a 00 00 00       	push   0x1a
    11d9:	f2 e9 41 fe ff ff    	bnd jmp 1020 <_init+0x20>
    11df:	90                   	nop
    11e0:	f3 0f 1e fa          	endbr64
    11e4:	68 1b 00 00 00       	push   0x1b
    11e9:	f2 e9 31 fe ff ff    	bnd jmp 1020 <_init+0x20>
    11ef:	90                   	nop

Disassembly of section .plt.got:

00000000000011f0 <__cxa_finalize@plt>:
    11f0:	f3 0f 1e fa          	endbr64
    11f4:	f2 ff 25 fd 3d 00 00 	bnd jmp QWORD PTR [rip+0x3dfd]        # 4ff8 <__cxa_finalize@GLIBC_2.2.5>
    11fb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

Disassembly of section .plt.sec:

0000000000001200 <getenv@plt>:
    1200:	f3 0f 1e fa          	endbr64
    1204:	f2 ff 25 ed 3c 00 00 	bnd jmp QWORD PTR [rip+0x3ced]        # 4ef8 <getenv@GLIBC_2.2.5>
    120b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001210 <__snprintf_chk@plt>:
    1210:	f3 0f 1e fa          	endbr64
    1214:	f2 ff 25 e5 3c 00 00 	bnd jmp QWORD PTR [rip+0x3ce5]        # 4f00 <__snprintf_chk@GLIBC_2.3.4>
    121b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001220 <free@plt>:
    1220:	f3 0f 1e fa          	endbr64
    1224:	f2 ff 25 dd 3c 00 00 	bnd jmp QWORD PTR [rip+0x3cdd]        # 4f08 <free@GLIBC_2.2.5>
    122b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001230 <strcasecmp@plt>:
    1230:	f3 0f 1e fa          	endbr64
    1234:	f2 ff 25 d5 3c 00 00 	bnd jmp QWORD PTR [rip+0x3cd5]        # 4f10 <strcasecmp@GLIBC_2.2.5>
    123b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001240 <__errno_location@plt>:
    1240:	f3 0f 1e fa          	endbr64
    1244:	f2 ff 25 cd 3c 00 00 	bnd jmp QWORD PTR [rip+0x3ccd]        # 4f18 <__errno_location@GLIBC_2.2.5>
    124b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001250 <strncmp@plt>:
    1250:	f3 0f 1e fa          	endbr64
    1254:	f2 ff 25 c5 3c 00 00 	bnd jmp QWORD PTR [rip+0x3cc5]        # 4f20 <strncmp@GLIBC_2.2.5>
    125b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001260 <fclose@plt>:
    1260:	f3 0f 1e fa          	endbr64
    1264:	f2 ff 25 bd 3c 00 00 	bnd jmp QWORD PTR [rip+0x3cbd]        # 4f28 <fclose@GLIBC_2.2.5>
    126b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001270 <strlen@plt>:
    1270:	f3 0f 1e fa          	endbr64
    1274:	f2 ff 25 b5 3c 00 00 	bnd jmp QWORD PTR [rip+0x3cb5]        # 4f30 <strlen@GLIBC_2.2.5>
    127b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001280 <__stack_chk_fail@plt>:
    1280:	f3 0f 1e fa          	endbr64
    1284:	f2 ff 25 ad 3c 00 00 	bnd jmp QWORD PTR [rip+0x3cad]        # 4f38 <__stack_chk_fail@GLIBC_2.4>
    128b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001290 <snprintf@plt>:
    1290:	f3 0f 1e fa          	endbr64
    1294:	f2 ff 25 a5 3c 00 00 	bnd jmp QWORD PTR [rip+0x3ca5]        # 4f40 <snprintf@GLIBC_2.2.5>
    129b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000012a0 <uname@plt>:
    12a0:	f3 0f 1e fa          	endbr64
    12a4:	f2 ff 25 9d 3c 00 00 	bnd jmp QWORD PTR [rip+0x3c9d]        # 4f48 <uname@GLIBC_2.2.5>
    12ab:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000012b0 <gmtime_r@plt>:
    12b0:	f3 0f 1e fa          	endbr64
    12b4:	f2 ff 25 95 3c 00 00 	bnd jmp QWORD PTR [rip+0x3c95]        # 4f50 <gmtime_r@GLIBC_2.2.5>
    12bb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000012c0 <fputc@plt>:
    12c0:	f3 0f 1e fa          	endbr64
    12c4:	f2 ff 25 8d 3c 00 00 	bnd jmp QWORD PTR [rip+0x3c8d]        # 4f58 <fputc@GLIBC_2.2.5>
    12cb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000012d0 <strtok_r@plt>:
    12d0:	f3 0f 1e fa          	endbr64
    12d4:	f2 ff 25 85 3c 00 00 	bnd jmp QWORD PTR [rip+0x3c85]        # 4f60 <strtok_r@GLIBC_2.2.5>
    12db:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000012e0 <fgets@plt>:
    12e0:	f3 0f 1e fa          	endbr64
    12e4:	f2 ff 25 7d 3c 00 00 	bnd jmp QWORD PTR [rip+0x3c7d]        # 4f68 <fgets@GLIBC_2.2.5>
    12eb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000012f0 <strtoull@plt>:
    12f0:	f3 0f 1e fa          	endbr64
    12f4:	f2 ff 25 75 3c 00 00 	bnd jmp QWORD PTR [rip+0x3c75]        # 4f70 <strtoull@GLIBC_2.2.5>
    12fb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001300 <strcmp@plt>:
    1300:	f3 0f 1e fa          	endbr64
    1304:	f2 ff 25 6d 3c 00 00 	bnd jmp QWORD PTR [rip+0x3c6d]        # 4f78 <strcmp@GLIBC_2.2.5>
    130b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001310 <time@plt>:
    1310:	f3 0f 1e fa          	endbr64
    1314:	f2 ff 25 65 3c 00 00 	bnd jmp QWORD PTR [rip+0x3c65]        # 4f80 <time@GLIBC_2.2.5>
    131b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001320 <malloc@plt>:
    1320:	f3 0f 1e fa          	endbr64
    1324:	f2 ff 25 5d 3c 00 00 	bnd jmp QWORD PTR [rip+0x3c5d]        # 4f88 <malloc@GLIBC_2.2.5>
    132b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001330 <realloc@plt>:
    1330:	f3 0f 1e fa          	endbr64
    1334:	f2 ff 25 55 3c 00 00 	bnd jmp QWORD PTR [rip+0x3c55]        # 4f90 <realloc@GLIBC_2.2.5>
    133b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001340 <strftime@plt>:
    1340:	f3 0f 1e fa          	endbr64
    1344:	f2 ff 25 4d 3c 00 00 	bnd jmp QWORD PTR [rip+0x3c4d]        # 4f98 <strftime@GLIBC_2.2.5>
    134b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001350 <fopen@plt>:
    1350:	f3 0f 1e fa          	endbr64
    1354:	f2 ff 25 45 3c 00 00 	bnd jmp QWORD PTR [rip+0x3c45]        # 4fa0 <fopen@GLIBC_2.2.5>
    135b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001360 <sched_getcpu@plt>:
    1360:	f3 0f 1e fa          	endbr64
    1364:	f2 ff 25 3d 3c 00 00 	bnd jmp QWORD PTR [rip+0x3c3d]        # 4fa8 <sched_getcpu@GLIBC_2.6>
    136b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001370 <fwrite@plt>:
    1370:	f3 0f 1e fa          	endbr64
    1374:	f2 ff 25 35 3c 00 00 	bnd jmp QWORD PTR [rip+0x3c35]        # 4fb0 <fwrite@GLIBC_2.2.5>
    137b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001380 <__fprintf_chk@plt>:
    1380:	f3 0f 1e fa          	endbr64
    1384:	f2 ff 25 2d 3c 00 00 	bnd jmp QWORD PTR [rip+0x3c2d]        # 4fb8 <__fprintf_chk@GLIBC_2.3.4>
    138b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001390 <posix_memalign@plt>:
    1390:	f3 0f 1e fa          	endbr64
    1394:	f2 ff 25 25 3c 00 00 	bnd jmp QWORD PTR [rip+0x3c25]        # 4fc0 <posix_memalign@GLIBC_2.2.5>
    139b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000013a0 <strdup@plt>:
    13a0:	f3 0f 1e fa          	endbr64
    13a4:	f2 ff 25 1d 3c 00 00 	bnd jmp QWORD PTR [rip+0x3c1d]        # 4fc8 <strdup@GLIBC_2.2.5>
    13ab:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000013b0 <strerror@plt>:
    13b0:	f3 0f 1e fa          	endbr64
    13b4:	f2 ff 25 15 3c 00 00 	bnd jmp QWORD PTR [rip+0x3c15]        # 4fd0 <strerror@GLIBC_2.2.5>
    13bb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

Disassembly of section .text:

00000000000013c0 <main>:
    13c0:	f3 0f 1e fa          	endbr64
    13c4:	41 57                	push   r15
    13c6:	41 56                	push   r14
    13c8:	41 55                	push   r13
    13ca:	41 89 fd             	mov    r13d,edi
    13cd:	48 8d 3d 73 1c 00 00 	lea    rdi,[rip+0x1c73]        # 3047 <_IO_stdin_used+0x47>
    13d4:	41 54                	push   r12
    13d6:	55                   	push   rbp
    13d7:	48 89 f5             	mov    rbp,rsi
    13da:	53                   	push   rbx
    13db:	48 81 ec e8 05 00 00 	sub    rsp,0x5e8
    13e2:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    13e9:	00 00
    13eb:	48 89 84 24 d8 05 00 	mov    QWORD PTR [rsp+0x5d8],rax
    13f2:	00
    13f3:	31 c0                	xor    eax,eax
    13f5:	e8 06 fe ff ff       	call   1200 <getenv@plt>
    13fa:	48 c7 84 24 30 01 00 	mov    QWORD PTR [rsp+0x130],0x30d40
    1401:	00 40 0d 03 00
    1406:	48 89 44 24 30       	mov    QWORD PTR [rsp+0x30],rax
    140b:	48 c7 84 24 38 01 00 	mov    QWORD PTR [rsp+0x138],0x5
    1412:	00 05 00 00 00
    1417:	48 c7 84 24 40 01 00 	mov    QWORD PTR [rsp+0x140],0x3
    141e:	00 03 00 00 00
    1423:	48 c7 84 24 48 01 00 	mov    QWORD PTR [rsp+0x148],0x1352904
    142a:	00 04 29 35 01
    142f:	48 c7 84 24 50 01 00 	mov    QWORD PTR [rsp+0x150],0x100
    1436:	00 00 01 00 00
    143b:	41 83 fd 01          	cmp    r13d,0x1
    143f:	0f 8e cd 09 00 00    	jle    1e12 <main+0xa52>
    1445:	48 8d 45 08          	lea    rax,[rbp+0x8]
    1449:	bb 02 00 00 00       	mov    ebx,0x2
    144e:	45 31 e4             	xor    r12d,r12d
    1451:	48 c7 44 24 10 00 00 	mov    QWORD PTR [rsp+0x10],0x0
    1458:	00 00
    145a:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
    145f:	41 8d 45 fe          	lea    eax,[r13-0x2]
    1463:	4c 8d 3d ad 1b 00 00 	lea    r15,[rip+0x1bad]        # 3017 <_IO_stdin_used+0x17>
    146a:	83 e0 fe             	and    eax,0xfffffffe
    146d:	83 c0 04             	add    eax,0x4
    1470:	89 44 24 28          	mov    DWORD PTR [rsp+0x28],eax
    1474:	48 8d 05 af 1b 00 00 	lea    rax,[rip+0x1baf]        # 302a <_IO_stdin_used+0x2a>
    147b:	48 89 44 24 18       	mov    QWORD PTR [rsp+0x18],rax
    1480:	48 8d 05 e9 1c 00 00 	lea    rax,[rip+0x1ce9]        # 3170 <_IO_stdin_used+0x170>
    1487:	48 89 44 24 08       	mov    QWORD PTR [rsp+0x8],rax
    148c:	eb 1c                	jmp    14aa <main+0xea>
    148e:	44 39 eb             	cmp    ebx,r13d
    1491:	7d 49                	jge    14dc <main+0x11c>
    1493:	48 63 c3             	movsxd rax,ebx
    1496:	4c 8b 64 c5 00       	mov    r12,QWORD PTR [rbp+rax*8+0x0]
    149b:	48 83 44 24 20 10    	add    QWORD PTR [rsp+0x20],0x10
    14a1:	83 c3 02             	add    ebx,0x2
    14a4:	39 5c 24 28          	cmp    DWORD PTR [rsp+0x28],ebx
    14a8:	74 6e                	je     1518 <main+0x158>
    14aa:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
    14af:	48 8d 35 9c 1b 00 00 	lea    rsi,[rip+0x1b9c]        # 3052 <_IO_stdin_used+0x52>
    14b6:	4c 8b 30             	mov    r14,QWORD PTR [rax]
    14b9:	4c 89 f7             	mov    rdi,r14
    14bc:	e8 3f fe ff ff       	call   1300 <strcmp@plt>
    14c1:	85 c0                	test   eax,eax
    14c3:	0f 84 49 04 00 00    	je     1912 <main+0x552>
    14c9:	48 8d 35 89 1b 00 00 	lea    rsi,[rip+0x1b89]        # 3059 <_IO_stdin_used+0x59>
    14d0:	4c 89 f7             	mov    rdi,r14
    14d3:	e8 28 fe ff ff       	call   1300 <strcmp@plt>
    14d8:	85 c0                	test   eax,eax
    14da:	74 b2                	je     148e <main+0xce>
    14dc:	48 8d 35 83 1b 00 00 	lea    rsi,[rip+0x1b83]        # 3066 <_IO_stdin_used+0x66>
    14e3:	4c 89 f7             	mov    rdi,r14
    14e6:	e8 15 fe ff ff       	call   1300 <strcmp@plt>
    14eb:	85 c0                	test   eax,eax
    14ed:	0f 85 ed 01 00 00    	jne    16e0 <main+0x320>
    14f3:	44 39 eb             	cmp    ebx,r13d
    14f6:	0f 8d e4 01 00 00    	jge    16e0 <main+0x320>
    14fc:	48 63 c3             	movsxd rax,ebx
    14ff:	48 83 44 24 20 10    	add    QWORD PTR [rsp+0x20],0x10
    1505:	83 c3 02             	add    ebx,0x2
    1508:	48 8b 44 c5 00       	mov    rax,QWORD PTR [rbp+rax*8+0x0]
    150d:	48 89 44 24 30       	mov    QWORD PTR [rsp+0x30],rax
    1512:	39 5c 24 28          	cmp    DWORD PTR [rsp+0x28],ebx
    1516:	75 92                	jne    14aa <main+0xea>
    1518:	4c 8b ac 24 30 01 00 	mov    r13,QWORD PTR [rsp+0x130]
    151f:	00
    1520:	48 b8 fe ff ff ff ff 	movabs rax,0x1ffffffffffffffe
    1527:	ff ff 1f
    152a:	49 8d 55 ff          	lea    rdx,[r13-0x1]
    152e:	48 39 c2             	cmp    rdx,rax
    1531:	0f 87 cf 08 00 00    	ja     1e06 <main+0xa46>
    1537:	48 8b 84 24 38 01 00 	mov    rax,QWORD PTR [rsp+0x138]
    153e:	00
    153f:	48 89 84 24 b0 00 00 	mov    QWORD PTR [rsp+0xb0],rax
    1546:	00
    1547:	48 83 e8 01          	sub    rax,0x1
    154b:	48 3d fe ff ff 7f    	cmp    rax,0x7ffffffe
    1551:	0f 87 a3 08 00 00    	ja     1dfa <main+0xa3a>
    1557:	48 8b 84 24 40 01 00 	mov    rax,QWORD PTR [rsp+0x140]
    155e:	00
    155f:	48 89 84 24 88 00 00 	mov    QWORD PTR [rsp+0x88],rax
    1566:	00
    1567:	48 83 e8 01          	sub    rax,0x1
    156b:	48 3d fe ff ff 7f    	cmp    rax,0x7ffffffe
    1571:	0f 87 83 08 00 00    	ja     1dfa <main+0xa3a>
    1577:	48 83 bc 24 50 01 00 	cmp    QWORD PTR [rsp+0x150],0x0
    157e:	00 00
    1580:	0f 84 55 08 00 00    	je     1ddb <main+0xa1b>
    1586:	4c 89 ff             	mov    rdi,r15
    1589:	e8 12 fe ff ff       	call   13a0 <strdup@plt>
    158e:	49 89 c7             	mov    r15,rax
    1591:	48 85 c0             	test   rax,rax
    1594:	0f 84 19 01 00 00    	je     16b3 <main+0x2f3>
    159a:	48 8d ac 24 58 01 00 	lea    rbp,[rsp+0x158]
    15a1:	00
    15a2:	48 89 c7             	mov    rdi,rax
    15a5:	4c 8d 35 a7 1b 00 00 	lea    r14,[rip+0x1ba7]        # 3153 <_IO_stdin_used+0x153>
    15ac:	48 c7 84 24 58 01 00 	mov    QWORD PTR [rsp+0x158],0x0
    15b3:	00 00 00 00 00
    15b8:	48 89 ea             	mov    rdx,rbp
    15bb:	4c 89 f6             	mov    rsi,r14
    15be:	e8 0d fd ff ff       	call   12d0 <strtok_r@plt>
    15c3:	48 89 c7             	mov    rdi,rax
    15c6:	48 85 c0             	test   rax,rax
    15c9:	0f 84 dc 00 00 00    	je     16ab <main+0x2eb>
    15cf:	31 db                	xor    ebx,ebx
    15d1:	31 c9                	xor    ecx,ecx
    15d3:	4c 89 64 24 20       	mov    QWORD PTR [rsp+0x20],r12
    15d8:	48 8d 84 24 60 01 00 	lea    rax,[rsp+0x160]
    15df:	00
    15e0:	49 89 dc             	mov    r12,rbx
    15e3:	48 89 84 24 d0 00 00 	mov    QWORD PTR [rsp+0xd0],rax
    15ea:	00
    15eb:	48 89 eb             	mov    rbx,rbp
    15ee:	48 89 cd             	mov    rbp,rcx
    15f1:	48 c7 84 24 e0 00 00 	mov    QWORD PTR [rsp+0xe0],0x0
    15f8:	00 00 00 00 00
    15fd:	eb 42                	jmp    1641 <main+0x281>
    15ff:	48 8b 84 24 e0 00 00 	mov    rax,QWORD PTR [rsp+0xe0]
    1606:	00
    1607:	31 ff                	xor    edi,edi
    1609:	4c 89 f6             	mov    rsi,r14
    160c:	48 83 c0 01          	add    rax,0x1
    1610:	48 89 54 c5 f8       	mov    QWORD PTR [rbp+rax*8-0x8],rdx
    1615:	48 89 da             	mov    rdx,rbx
    1618:	48 89 84 24 f0 00 00 	mov    QWORD PTR [rsp+0xf0],rax
    161f:	00
    1620:	e8 ab fc ff ff       	call   12d0 <strtok_r@plt>
    1625:	48 89 c7             	mov    rdi,rax
    1628:	48 85 c0             	test   rax,rax
    162b:	0f 84 2c 03 00 00    	je     195d <main+0x59d>
    1631:	48 8b 84 24 f0 00 00 	mov    rax,QWORD PTR [rsp+0xf0]
    1638:	00
    1639:	48 89 84 24 e0 00 00 	mov    QWORD PTR [rsp+0xe0],rax
    1640:	00
    1641:	48 8b b4 24 d0 00 00 	mov    rsi,QWORD PTR [rsp+0xd0]
    1648:	00
    1649:	48 c7 84 24 60 01 00 	mov    QWORD PTR [rsp+0x160],0x0
    1650:	00 00 00 00 00
    1655:	e8 d6 16 00 00       	call   2d30 <parse_ull>
    165a:	85 c0                	test   eax,eax
    165c:	75 4d                	jne    16ab <main+0x2eb>
    165e:	48 8b 94 24 60 01 00 	mov    rdx,QWORD PTR [rsp+0x160]
    1665:	00
    1666:	48 81 fa 40 42 0f 00 	cmp    rdx,0xf4240
    166d:	77 3c                	ja     16ab <main+0x2eb>
    166f:	4c 3b a4 24 e0 00 00 	cmp    r12,QWORD PTR [rsp+0xe0]
    1676:	00
    1677:	75 86                	jne    15ff <main+0x23f>
    1679:	4d 85 e4             	test   r12,r12
    167c:	0f 84 d0 02 00 00    	je     1952 <main+0x592>
    1682:	4d 01 e4             	add    r12,r12
    1685:	48 89 ef             	mov    rdi,rbp
    1688:	4a 8d 34 e5 00 00 00 	lea    rsi,[r12*8+0x0]
    168f:	00
    1690:	48 89 54 24 28       	mov    QWORD PTR [rsp+0x28],rdx
    1695:	e8 96 fc ff ff       	call   1330 <realloc@plt>
    169a:	48 8b 54 24 28       	mov    rdx,QWORD PTR [rsp+0x28]
    169f:	48 85 c0             	test   rax,rax
    16a2:	48 89 c5             	mov    rbp,rax
    16a5:	0f 85 54 ff ff ff    	jne    15ff <main+0x23f>
    16ab:	4c 89 ff             	mov    rdi,r15
    16ae:	e8 6d fb ff ff       	call   1220 <free@plt>
    16b3:	48 8d 15 7e 1f 00 00 	lea    rdx,[rip+0x1f7e]        # 3638 <_IO_stdin_used+0x638>
    16ba:	48 8b 3d 7f 39 00 00 	mov    rdi,QWORD PTR [rip+0x397f]        # 5040 <stderr@GLIBC_2.2.5>
    16c1:	be 01 00 00 00       	mov    esi,0x1
    16c6:	31 c0                	xor    eax,eax
    16c8:	e8 b3 fc ff ff       	call   1380 <__fprintf_chk@plt>
    16cd:	c7 84 24 ac 00 00 00 	mov    DWORD PTR [rsp+0xac],0x2
    16d4:	02 00 00 00
    16d8:	e9 45 02 00 00       	jmp    1922 <main+0x562>
    16dd:	0f 1f 00             	nop    DWORD PTR [rax]
    16e0:	48 8d 35 8c 19 00 00 	lea    rsi,[rip+0x198c]        # 3073 <_IO_stdin_used+0x73>
    16e7:	4c 89 f7             	mov    rdi,r14
    16ea:	e8 11 fc ff ff       	call   1300 <strcmp@plt>
    16ef:	85 c0                	test   eax,eax
    16f1:	75 12                	jne    1705 <main+0x345>
    16f3:	44 39 eb             	cmp    ebx,r13d
    16f6:	7d 0d                	jge    1705 <main+0x345>
    16f8:	48 63 c3             	movsxd rax,ebx
    16fb:	4c 8b 7c c5 00       	mov    r15,QWORD PTR [rbp+rax*8+0x0]
    1700:	e9 96 fd ff ff       	jmp    149b <main+0xdb>
    1705:	48 8d 35 6e 19 00 00 	lea    rsi,[rip+0x196e]        # 307a <_IO_stdin_used+0x7a>
    170c:	4c 89 f7             	mov    rdi,r14
    170f:	e8 ec fb ff ff       	call   1300 <strcmp@plt>
    1714:	85 c0                	test   eax,eax
    1716:	75 17                	jne    172f <main+0x36f>
    1718:	44 39 eb             	cmp    ebx,r13d
    171b:	7d 12                	jge    172f <main+0x36f>
    171d:	48 63 c3             	movsxd rax,ebx
    1720:	48 8b 44 c5 00       	mov    rax,QWORD PTR [rbp+rax*8+0x0]
    1725:	48 89 44 24 08       	mov    QWORD PTR [rsp+0x8],rax
    172a:	e9 6c fd ff ff       	jmp    149b <main+0xdb>
    172f:	48 8d 35 55 19 00 00 	lea    rsi,[rip+0x1955]        # 308b <_IO_stdin_used+0x8b>
    1736:	4c 89 f7             	mov    rdi,r14
    1739:	e8 c2 fb ff ff       	call   1300 <strcmp@plt>
    173e:	85 c0                	test   eax,eax
    1740:	75 17                	jne    1759 <main+0x399>
    1742:	44 39 eb             	cmp    ebx,r13d
    1745:	7d 12                	jge    1759 <main+0x399>
    1747:	48 63 c3             	movsxd rax,ebx
    174a:	48 8b 44 c5 00       	mov    rax,QWORD PTR [rbp+rax*8+0x0]
    174f:	48 89 44 24 18       	mov    QWORD PTR [rsp+0x18],rax
    1754:	e9 42 fd ff ff       	jmp    149b <main+0xdb>
    1759:	48 8d 35 39 19 00 00 	lea    rsi,[rip+0x1939]        # 3099 <_IO_stdin_used+0x99>
    1760:	4c 89 f7             	mov    rdi,r14
    1763:	e8 98 fb ff ff       	call   1300 <strcmp@plt>
    1768:	85 c0                	test   eax,eax
    176a:	75 09                	jne    1775 <main+0x3b5>
    176c:	44 39 eb             	cmp    ebx,r13d
    176f:	0f 8c 89 00 00 00    	jl     17fe <main+0x43e>
    1775:	48 8d 35 2a 19 00 00 	lea    rsi,[rip+0x192a]        # 30a6 <_IO_stdin_used+0xa6>
    177c:	4c 89 f7             	mov    rdi,r14
    177f:	e8 7c fb ff ff       	call   1300 <strcmp@plt>
    1784:	85 c0                	test   eax,eax
    1786:	0f 85 14 01 00 00    	jne    18a0 <main+0x4e0>
    178c:	44 39 eb             	cmp    ebx,r13d
    178f:	0f 8c e0 00 00 00    	jl     1875 <main+0x4b5>
    1795:	48 8d 35 1a 19 00 00 	lea    rsi,[rip+0x191a]        # 30b6 <_IO_stdin_used+0xb6>
    179c:	4c 89 f7             	mov    rdi,r14
    179f:	e8 5c fb ff ff       	call   1300 <strcmp@plt>
    17a4:	85 c0                	test   eax,eax
    17a6:	0f 85 84 00 00 00    	jne    1830 <main+0x470>
    17ac:	44 39 eb             	cmp    ebx,r13d
    17af:	0f 8c 34 01 00 00    	jl     18e9 <main+0x529>
    17b5:	48 8d 35 01 19 00 00 	lea    rsi,[rip+0x1901]        # 30bd <_IO_stdin_used+0xbd>
    17bc:	4c 89 f7             	mov    rdi,r14
    17bf:	e8 3c fb ff ff       	call   1300 <strcmp@plt>
    17c4:	85 c0                	test   eax,eax
    17c6:	0f 84 88 06 00 00    	je     1e54 <main+0xa94>
    17cc:	48 8d 35 f3 18 00 00 	lea    rsi,[rip+0x18f3]        # 30c6 <_IO_stdin_used+0xc6>
    17d3:	4c 89 f7             	mov    rdi,r14
    17d6:	e8 25 fb ff ff       	call   1300 <strcmp@plt>
    17db:	85 c0                	test   eax,eax
    17dd:	0f 85 71 06 00 00    	jne    1e54 <main+0xa94>
    17e3:	44 39 eb             	cmp    ebx,r13d
    17e6:	0f 8d 68 06 00 00    	jge    1e54 <main+0xa94>
    17ec:	48 63 c3             	movsxd rax,ebx
    17ef:	48 8b 44 c5 00       	mov    rax,QWORD PTR [rbp+rax*8+0x0]
    17f4:	48 89 44 24 10       	mov    QWORD PTR [rsp+0x10],rax
    17f9:	e9 9d fc ff ff       	jmp    149b <main+0xdb>
    17fe:	48 63 c3             	movsxd rax,ebx
    1801:	48 8d b4 24 30 01 00 	lea    rsi,[rsp+0x130]
    1808:	00
    1809:	48 8b 7c c5 00       	mov    rdi,QWORD PTR [rbp+rax*8+0x0]
    180e:	e8 1d 15 00 00       	call   2d30 <parse_ull>
    1813:	85 c0                	test   eax,eax
    1815:	0f 84 80 fc ff ff    	je     149b <main+0xdb>
    181b:	48 8d 15 9e 1c 00 00 	lea    rdx,[rip+0x1c9e]        # 34c0 <_IO_stdin_used+0x4c0>
    1822:	e9 93 fe ff ff       	jmp    16ba <main+0x2fa>
    1827:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
    182e:	00 00
    1830:	48 8d 35 86 18 00 00 	lea    rsi,[rip+0x1886]        # 30bd <_IO_stdin_used+0xbd>
    1837:	4c 89 f7             	mov    rdi,r14
    183a:	e8 c1 fa ff ff       	call   1300 <strcmp@plt>
    183f:	85 c0                	test   eax,eax
    1841:	75 89                	jne    17cc <main+0x40c>
    1843:	44 39 eb             	cmp    ebx,r13d
    1846:	0f 8d 08 06 00 00    	jge    1e54 <main+0xa94>
    184c:	48 63 c3             	movsxd rax,ebx
    184f:	48 8d b4 24 50 01 00 	lea    rsi,[rsp+0x150]
    1856:	00
    1857:	48 8b 7c c5 00       	mov    rdi,QWORD PTR [rbp+rax*8+0x0]
    185c:	e8 cf 14 00 00       	call   2d30 <parse_ull>
    1861:	85 c0                	test   eax,eax
    1863:	0f 84 32 fc ff ff    	je     149b <main+0xdb>
    1869:	48 8d 15 00 1d 00 00 	lea    rdx,[rip+0x1d00]        # 3570 <_IO_stdin_used+0x570>
    1870:	e9 45 fe ff ff       	jmp    16ba <main+0x2fa>
    1875:	48 63 c3             	movsxd rax,ebx
    1878:	48 8d b4 24 38 01 00 	lea    rsi,[rsp+0x138]
    187f:	00
    1880:	48 8b 7c c5 00       	mov    rdi,QWORD PTR [rbp+rax*8+0x0]
    1885:	e8 a6 14 00 00       	call   2d30 <parse_ull>
    188a:	85 c0                	test   eax,eax
    188c:	0f 84 09 fc ff ff    	je     149b <main+0xdb>
    1892:	48 8d 15 57 1c 00 00 	lea    rdx,[rip+0x1c57]        # 34f0 <_IO_stdin_used+0x4f0>
    1899:	e9 1c fe ff ff       	jmp    16ba <main+0x2fa>
    189e:	66 90                	xchg   ax,ax
    18a0:	48 8d 35 08 18 00 00 	lea    rsi,[rip+0x1808]        # 30af <_IO_stdin_used+0xaf>
    18a7:	4c 89 f7             	mov    rdi,r14
    18aa:	e8 51 fa ff ff       	call   1300 <strcmp@plt>
    18af:	85 c0                	test   eax,eax
    18b1:	0f 85 de fe ff ff    	jne    1795 <main+0x3d5>
    18b7:	44 39 eb             	cmp    ebx,r13d
    18ba:	0f 8d d5 fe ff ff    	jge    1795 <main+0x3d5>
    18c0:	48 63 c3             	movsxd rax,ebx
    18c3:	48 8d b4 24 40 01 00 	lea    rsi,[rsp+0x140]
    18ca:	00
    18cb:	48 8b 7c c5 00       	mov    rdi,QWORD PTR [rbp+rax*8+0x0]
    18d0:	e8 5b 14 00 00       	call   2d30 <parse_ull>
    18d5:	85 c0                	test   eax,eax
    18d7:	0f 84 be fb ff ff    	je     149b <main+0xdb>
    18dd:	48 8d 15 3c 1c 00 00 	lea    rdx,[rip+0x1c3c]        # 3520 <_IO_stdin_used+0x520>
    18e4:	e9 d1 fd ff ff       	jmp    16ba <main+0x2fa>
    18e9:	48 63 c3             	movsxd rax,ebx
    18ec:	48 8d b4 24 48 01 00 	lea    rsi,[rsp+0x148]
    18f3:	00
    18f4:	48 8b 7c c5 00       	mov    rdi,QWORD PTR [rbp+rax*8+0x0]
    18f9:	e8 32 14 00 00       	call   2d30 <parse_ull>
    18fe:	85 c0                	test   eax,eax
    1900:	0f 84 95 fb ff ff    	je     149b <main+0xdb>
    1906:	48 8d 15 3b 1c 00 00 	lea    rdx,[rip+0x1c3b]        # 3548 <_IO_stdin_used+0x548>
    190d:	e9 a8 fd ff ff       	jmp    16ba <main+0x2fa>
    1912:	48 8b 7d 00          	mov    rdi,QWORD PTR [rbp+0x0]
    1916:	89 84 24 ac 00 00 00 	mov    DWORD PTR [rsp+0xac],eax
    191d:	e8 3e 16 00 00       	call   2f60 <usage>
    1922:	48 8b 84 24 d8 05 00 	mov    rax,QWORD PTR [rsp+0x5d8]
    1929:	00
    192a:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
    1931:	00 00
    1933:	0f 85 51 05 00 00    	jne    1e8a <main+0xaca>
    1939:	8b 84 24 ac 00 00 00 	mov    eax,DWORD PTR [rsp+0xac]
    1940:	48 81 c4 e8 05 00 00 	add    rsp,0x5e8
    1947:	5b                   	pop    rbx
    1948:	5d                   	pop    rbp
    1949:	41 5c                	pop    r12
    194b:	41 5d                	pop    r13
    194d:	41 5e                	pop    r14
    194f:	41 5f                	pop    r15
    1951:	c3                   	ret
    1952:	41 bc 10 00 00 00    	mov    r12d,0x10
    1958:	e9 28 fd ff ff       	jmp    1685 <main+0x2c5>
    195d:	4c 89 ff             	mov    rdi,r15
    1960:	48 89 ac 24 d8 00 00 	mov    QWORD PTR [rsp+0xd8],rbp
    1967:	00
    1968:	4c 8b 64 24 20       	mov    r12,QWORD PTR [rsp+0x20]
    196d:	48 89 dd             	mov    rbp,rbx
    1970:	48 89 84 24 c0 00 00 	mov    QWORD PTR [rsp+0xc0],rax
    1977:	00
    1978:	e8 a3 f8 ff ff       	call   1220 <free@plt>
    197d:	48 83 bc 24 f0 00 00 	cmp    QWORD PTR [rsp+0xf0],0x0
    1984:	00 00
    1986:	0f 84 27 fd ff ff    	je     16b3 <main+0x2f3>
    198c:	48 8b 7c 24 08       	mov    rdi,QWORD PTR [rsp+0x8]
    1991:	e8 0a fa ff ff       	call   13a0 <strdup@plt>
    1996:	49 89 c7             	mov    r15,rax
    1999:	48 85 c0             	test   rax,rax
    199c:	0f 84 f7 03 00 00    	je     1d99 <main+0x9d9>
    19a2:	48 89 ea             	mov    rdx,rbp
    19a5:	4c 89 f6             	mov    rsi,r14
    19a8:	48 89 c7             	mov    rdi,rax
    19ab:	48 c7 84 24 58 01 00 	mov    QWORD PTR [rsp+0x158],0x0
    19b2:	00 00 00 00 00
    19b7:	e8 14 f9 ff ff       	call   12d0 <strtok_r@plt>
    19bc:	48 85 c0             	test   rax,rax
    19bf:	0f 84 da 0f 00 00    	je     299f <main+0x15df>
    19c5:	31 f6                	xor    esi,esi
    19c7:	48 8d 8c 24 30 03 00 	lea    rcx,[rsp+0x330]
    19ce:	00
    19cf:	4c 89 6c 24 28       	mov    QWORD PTR [rsp+0x28],r13
    19d4:	31 db                	xor    ebx,ebx
    19d6:	4c 89 64 24 40       	mov    QWORD PTR [rsp+0x40],r12
    19db:	4c 8b ac 24 c0 00 00 	mov    r13,QWORD PTR [rsp+0xc0]
    19e2:	00
    19e3:	49 89 f4             	mov    r12,rsi
    19e6:	4c 89 7c 24 20       	mov    QWORD PTR [rsp+0x20],r15
    19eb:	49 89 c7             	mov    r15,rax
    19ee:	48 c7 44 24 08 00 00 	mov    QWORD PTR [rsp+0x8],0x0
    19f5:	00 00
    19f7:	48 89 4c 24 38       	mov    QWORD PTR [rsp+0x38],rcx
    19fc:	e9 d6 00 00 00       	jmp    1ad7 <main+0x717>
    1a01:	ba 08 00 00 00       	mov    edx,0x8
    1a06:	48 8d 35 c7 16 00 00 	lea    rsi,[rip+0x16c7]        # 30d4 <_IO_stdin_used+0xd4>
    1a0d:	4c 89 ff             	mov    rdi,r15
    1a10:	e8 3b f8 ff ff       	call   1250 <strncmp@plt>
    1a15:	85 c0                	test   eax,eax
    1a17:	0f 85 72 03 00 00    	jne    1d8f <main+0x9cf>
    1a1d:	48 8b b4 24 d0 00 00 	mov    rsi,QWORD PTR [rsp+0xd0]
    1a24:	00
    1a25:	49 8d 7f 08          	lea    rdi,[r15+0x8]
    1a29:	48 c7 84 24 60 01 00 	mov    QWORD PTR [rsp+0x160],0x0
    1a30:	00 00 00 00 00
    1a35:	e8 f6 12 00 00       	call   2d30 <parse_ull>
    1a3a:	85 c0                	test   eax,eax
    1a3c:	0f 85 4d 03 00 00    	jne    1d8f <main+0x9cf>
    1a42:	4c 8b bc 24 60 01 00 	mov    r15,QWORD PTR [rsp+0x160]
    1a49:	00
    1a4a:	49 8d 47 ff          	lea    rax,[r15-0x1]
    1a4e:	48 83 f8 63          	cmp    rax,0x63
    1a52:	0f 87 37 03 00 00    	ja     1d8f <main+0x9cf>
    1a58:	48 8b 7c 24 38       	mov    rdi,QWORD PTR [rsp+0x38]
    1a5d:	4d 89 f9             	mov    r9,r15
    1a60:	b9 20 00 00 00       	mov    ecx,0x20
    1a65:	31 c0                	xor    eax,eax
    1a67:	4c 8d 05 6f 16 00 00 	lea    r8,[rip+0x166f]        # 30dd <_IO_stdin_used+0xdd>
    1a6e:	ba 01 00 00 00       	mov    edx,0x1
    1a73:	be 20 00 00 00       	mov    esi,0x20
    1a78:	e8 93 f7 ff ff       	call   1210 <__snprintf_chk@plt>
    1a7d:	44 89 bc 24 50 03 00 	mov    DWORD PTR [rsp+0x350],r15d
    1a84:	00
    1a85:	4c 3b 64 24 08       	cmp    r12,QWORD PTR [rsp+0x8]
    1a8a:	0f 84 d7 02 00 00    	je     1d67 <main+0x9a7>
    1a90:	8b 84 24 50 03 00 00 	mov    eax,DWORD PTR [rsp+0x350]
    1a97:	48 89 ea             	mov    rdx,rbp
    1a9a:	4c 89 f6             	mov    rsi,r14
    1a9d:	31 ff                	xor    edi,edi
    1a9f:	66 0f 6f 9c 24 30 03 	movdqa xmm3,XMMWORD PTR [rsp+0x330]
    1aa6:	00 00
    1aa8:	49 83 c4 01          	add    r12,0x1
    1aac:	66 0f 6f a4 24 40 03 	movdqa xmm4,XMMWORD PTR [rsp+0x340]
    1ab3:	00 00
    1ab5:	41 89 44 1d 20       	mov    DWORD PTR [r13+rbx*1+0x20],eax
    1aba:	41 0f 11 5c 1d 00    	movups XMMWORD PTR [r13+rbx*1+0x0],xmm3
    1ac0:	41 0f 11 64 1d 10    	movups XMMWORD PTR [r13+rbx*1+0x10],xmm4
    1ac6:	48 83 c3 24          	add    rbx,0x24
    1aca:	e8 01 f8 ff ff       	call   12d0 <strtok_r@plt>
    1acf:	49 89 c7             	mov    r15,rax
    1ad2:	48 85 c0             	test   rax,rax
    1ad5:	74 39                	je     1b10 <main+0x750>
    1ad7:	48 8d 35 ee 15 00 00 	lea    rsi,[rip+0x15ee]        # 30cc <_IO_stdin_used+0xcc>
    1ade:	4c 89 ff             	mov    rdi,r15
    1ae1:	e8 1a f8 ff ff       	call   1300 <strcmp@plt>
    1ae6:	85 c0                	test   eax,eax
    1ae8:	0f 85 13 ff ff ff    	jne    1a01 <main+0x641>
    1aee:	48 b9 69 6e 72 61 6e 	movabs rcx,0x65676e61726e69
    1af5:	67 65 00
    1af8:	48 8b 44 24 38       	mov    rax,QWORD PTR [rsp+0x38]
    1afd:	48 89 08             	mov    QWORD PTR [rax],rcx
    1b00:	c7 84 24 50 03 00 00 	mov    DWORD PTR [rsp+0x350],0x0
    1b07:	00 00 00 00
    1b0b:	e9 75 ff ff ff       	jmp    1a85 <main+0x6c5>
    1b10:	48 8b 7c 24 20       	mov    rdi,QWORD PTR [rsp+0x20]
    1b15:	4c 89 a4 24 10 01 00 	mov    QWORD PTR [rsp+0x110],r12
    1b1c:	00
    1b1d:	4c 89 ac 24 c0 00 00 	mov    QWORD PTR [rsp+0xc0],r13
    1b24:	00
    1b25:	4c 8b 64 24 40       	mov    r12,QWORD PTR [rsp+0x40]
    1b2a:	48 89 84 24 c8 00 00 	mov    QWORD PTR [rsp+0xc8],rax
    1b31:	00
    1b32:	4c 8b 6c 24 28       	mov    r13,QWORD PTR [rsp+0x28]
    1b37:	e8 e4 f6 ff ff       	call   1220 <free@plt>
    1b3c:	48 83 bc 24 10 01 00 	cmp    QWORD PTR [rsp+0x110],0x0
    1b43:	00 00
    1b45:	0f 84 4e 02 00 00    	je     1d99 <main+0x9d9>
    1b4b:	48 8b 7c 24 18       	mov    rdi,QWORD PTR [rsp+0x18]
    1b50:	e8 4b f8 ff ff       	call   13a0 <strdup@plt>
    1b55:	49 89 c7             	mov    r15,rax
    1b58:	48 85 c0             	test   rax,rax
    1b5b:	0f 84 c2 01 00 00    	je     1d23 <main+0x963>
    1b61:	48 89 ea             	mov    rdx,rbp
    1b64:	4c 89 f6             	mov    rsi,r14
    1b67:	48 89 c7             	mov    rdi,rax
    1b6a:	48 c7 84 24 58 01 00 	mov    QWORD PTR [rsp+0x158],0x0
    1b71:	00 00 00 00 00
    1b76:	e8 55 f7 ff ff       	call   12d0 <strtok_r@plt>
    1b7b:	48 89 c1             	mov    rcx,rax
    1b7e:	48 85 c0             	test   rax,rax
    1b81:	0f 84 94 01 00 00    	je     1d1b <main+0x95b>
    1b87:	48 c7 44 24 18 00 00 	mov    QWORD PTR [rsp+0x18],0x0
    1b8e:	00 00
    1b90:	31 c0                	xor    eax,eax
    1b92:	4c 89 6c 24 28       	mov    QWORD PTR [rsp+0x28],r13
    1b97:	4c 89 64 24 40       	mov    QWORD PTR [rsp+0x40],r12
    1b9c:	49 89 c4             	mov    r12,rax
    1b9f:	4c 89 7c 24 08       	mov    QWORD PTR [rsp+0x8],r15
    1ba4:	49 89 cf             	mov    r15,rcx
    1ba7:	41 80 3f 00          	cmp    BYTE PTR [r15],0x0
    1bab:	0f 84 65 01 00 00    	je     1d16 <main+0x956>
    1bb1:	e8 8a f6 ff ff       	call   1240 <__errno_location@plt>
    1bb6:	48 8b b4 24 d0 00 00 	mov    rsi,QWORD PTR [rsp+0xd0]
    1bbd:	00
    1bbe:	ba 0a 00 00 00       	mov    edx,0xa
    1bc3:	4c 89 ff             	mov    rdi,r15
    1bc6:	c7 00 00 00 00 00    	mov    DWORD PTR [rax],0x0
    1bcc:	49 89 c5             	mov    r13,rax
    1bcf:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
    1bd4:	48 c7 84 24 60 01 00 	mov    QWORD PTR [rsp+0x160],0x0
    1bdb:	00 00 00 00 00
    1be0:	e8 0b f7 ff ff       	call   12f0 <strtoull@plt>
    1be5:	48 89 c3             	mov    rbx,rax
    1be8:	41 8b 45 00          	mov    eax,DWORD PTR [r13+0x0]
    1bec:	85 c0                	test   eax,eax
    1bee:	0f 85 22 01 00 00    	jne    1d16 <main+0x956>
    1bf4:	4c 8b ac 24 60 01 00 	mov    r13,QWORD PTR [rsp+0x160]
    1bfb:	00
    1bfc:	4d 39 fd             	cmp    r13,r15
    1bff:	0f 84 11 01 00 00    	je     1d16 <main+0x956>
    1c05:	41 80 7d 00 00       	cmp    BYTE PTR [r13+0x0],0x0
    1c0a:	0f 84 c2 00 00 00    	je     1cd2 <main+0x912>
    1c10:	48 8d 35 df 14 00 00 	lea    rsi,[rip+0x14df]        # 30f6 <_IO_stdin_used+0xf6>
    1c17:	4c 89 ef             	mov    rdi,r13
    1c1a:	e8 11 f6 ff ff       	call   1230 <strcasecmp@plt>
    1c1f:	85 c0                	test   eax,eax
    1c21:	0f 84 ab 00 00 00    	je     1cd2 <main+0x912>
    1c27:	48 8d 35 4a 14 00 00 	lea    rsi,[rip+0x144a]        # 3078 <_IO_stdin_used+0x78>
    1c2e:	4c 89 ef             	mov    rdi,r13
    1c31:	e8 fa f5 ff ff       	call   1230 <strcasecmp@plt>
    1c36:	85 c0                	test   eax,eax
    1c38:	0f 84 8d 00 00 00    	je     1ccb <main+0x90b>
    1c3e:	48 8d 35 a5 14 00 00 	lea    rsi,[rip+0x14a5]        # 30ea <_IO_stdin_used+0xea>
    1c45:	4c 89 ef             	mov    rdi,r13
    1c48:	e8 e3 f5 ff ff       	call   1230 <strcasecmp@plt>
    1c4d:	85 c0                	test   eax,eax
    1c4f:	74 7a                	je     1ccb <main+0x90b>
    1c51:	48 8d 35 96 14 00 00 	lea    rsi,[rip+0x1496]        # 30ee <_IO_stdin_used+0xee>
    1c58:	4c 89 ef             	mov    rdi,r13
    1c5b:	e8 d0 f5 ff ff       	call   1230 <strcasecmp@plt>
    1c60:	85 c0                	test   eax,eax
    1c62:	0f 85 44 0d 00 00    	jne    29ac <main+0x15ec>
    1c68:	b9 00 00 10 00       	mov    ecx,0x100000
    1c6d:	48 89 d8             	mov    rax,rbx
    1c70:	48 f7 e1             	mul    rcx
    1c73:	0f 80 9d 00 00 00    	jo     1d16 <main+0x956>
    1c79:	48 0f af d9          	imul   rbx,rcx
    1c7d:	48 83 fb 3f          	cmp    rbx,0x3f
    1c81:	0f 86 8f 00 00 00    	jbe    1d16 <main+0x956>
    1c87:	4c 3b 64 24 18       	cmp    r12,QWORD PTR [rsp+0x18]
    1c8c:	74 4b                	je     1cd9 <main+0x919>
    1c8e:	48 8b 84 24 c8 00 00 	mov    rax,QWORD PTR [rsp+0xc8]
    1c95:	00
    1c96:	31 ff                	xor    edi,edi
    1c98:	48 89 ea             	mov    rdx,rbp
    1c9b:	4c 89 f6             	mov    rsi,r14
    1c9e:	4d 8d 44 24 01       	lea    r8,[r12+0x1]
    1ca3:	4a 89 5c c0 f8       	mov    QWORD PTR [rax+r8*8-0x8],rbx
    1ca8:	4c 89 44 24 48       	mov    QWORD PTR [rsp+0x48],r8
    1cad:	e8 1e f6 ff ff       	call   12d0 <strtok_r@plt>
    1cb2:	4c 8b 44 24 48       	mov    r8,QWORD PTR [rsp+0x48]
    1cb7:	48 85 c0             	test   rax,rax
    1cba:	49 89 c7             	mov    r15,rax
    1cbd:	0f 84 cc 01 00 00    	je     1e8f <main+0xacf>
    1cc3:	4d 89 c4             	mov    r12,r8
    1cc6:	e9 dc fe ff ff       	jmp    1ba7 <main+0x7e7>
    1ccb:	b9 00 04 00 00       	mov    ecx,0x400
    1cd0:	eb 9b                	jmp    1c6d <main+0x8ad>
    1cd2:	b9 01 00 00 00       	mov    ecx,0x1
    1cd7:	eb a0                	jmp    1c79 <main+0x8b9>
    1cd9:	4d 85 e4             	test   r12,r12
    1cdc:	0f 84 0a 01 00 00    	je     1dec <main+0xa2c>
    1ce2:	4b 8d 04 24          	lea    rax,[r12+r12*1]
    1ce6:	48 89 44 24 18       	mov    QWORD PTR [rsp+0x18],rax
    1ceb:	48 8b 44 24 18       	mov    rax,QWORD PTR [rsp+0x18]
    1cf0:	48 8b bc 24 c8 00 00 	mov    rdi,QWORD PTR [rsp+0xc8]
    1cf7:	00
    1cf8:	48 8d 34 c5 00 00 00 	lea    rsi,[rax*8+0x0]
    1cff:	00
    1d00:	e8 2b f6 ff ff       	call   1330 <realloc@plt>
    1d05:	48 89 84 24 c8 00 00 	mov    QWORD PTR [rsp+0xc8],rax
    1d0c:	00
    1d0d:	48 85 c0             	test   rax,rax
    1d10:	0f 85 78 ff ff ff    	jne    1c8e <main+0x8ce>
    1d16:	4c 8b 7c 24 08       	mov    r15,QWORD PTR [rsp+0x8]
    1d1b:	4c 89 ff             	mov    rdi,r15
    1d1e:	e8 fd f4 ff ff       	call   1220 <free@plt>
    1d23:	48 8b 3d 16 33 00 00 	mov    rdi,QWORD PTR [rip+0x3316]        # 5040 <stderr@GLIBC_2.2.5>
    1d2a:	48 8d 15 7f 19 00 00 	lea    rdx,[rip+0x197f]        # 36b0 <_IO_stdin_used+0x6b0>
    1d31:	be 01 00 00 00       	mov    esi,0x1
    1d36:	31 c0                	xor    eax,eax
    1d38:	e8 43 f6 ff ff       	call   1380 <__fprintf_chk@plt>
    1d3d:	48 8b bc 24 d8 00 00 	mov    rdi,QWORD PTR [rsp+0xd8]
    1d44:	00
    1d45:	e8 d6 f4 ff ff       	call   1220 <free@plt>
    1d4a:	48 8b bc 24 c0 00 00 	mov    rdi,QWORD PTR [rsp+0xc0]
    1d51:	00
    1d52:	e8 c9 f4 ff ff       	call   1220 <free@plt>
    1d57:	c7 84 24 ac 00 00 00 	mov    DWORD PTR [rsp+0xac],0x2
    1d5e:	02 00 00 00
    1d62:	e9 bb fb ff ff       	jmp    1922 <main+0x562>
    1d67:	4d 85 e4             	test   r12,r12
    1d6a:	74 64                	je     1dd0 <main+0xa10>
    1d6c:	4b 8d 04 24          	lea    rax,[r12+r12*1]
    1d70:	48 89 44 24 08       	mov    QWORD PTR [rsp+0x8],rax
    1d75:	48 6b 74 24 08 24    	imul   rsi,QWORD PTR [rsp+0x8],0x24
    1d7b:	4c 89 ef             	mov    rdi,r13
    1d7e:	e8 ad f5 ff ff       	call   1330 <realloc@plt>
    1d83:	49 89 c5             	mov    r13,rax
    1d86:	48 85 c0             	test   rax,rax
    1d89:	0f 85 01 fd ff ff    	jne    1a90 <main+0x6d0>
    1d8f:	48 8b 7c 24 20       	mov    rdi,QWORD PTR [rsp+0x20]
    1d94:	e8 87 f4 ff ff       	call   1220 <free@plt>
    1d99:	48 8b 3d a0 32 00 00 	mov    rdi,QWORD PTR [rip+0x32a0]        # 5040 <stderr@GLIBC_2.2.5>
    1da0:	48 8d 15 c1 18 00 00 	lea    rdx,[rip+0x18c1]        # 3668 <_IO_stdin_used+0x668>
    1da7:	be 01 00 00 00       	mov    esi,0x1
    1dac:	31 c0                	xor    eax,eax
    1dae:	e8 cd f5 ff ff       	call   1380 <__fprintf_chk@plt>
    1db3:	48 8b bc 24 d8 00 00 	mov    rdi,QWORD PTR [rsp+0xd8]
    1dba:	00
    1dbb:	e8 60 f4 ff ff       	call   1220 <free@plt>
    1dc0:	c7 84 24 ac 00 00 00 	mov    DWORD PTR [rsp+0xac],0x2
    1dc7:	02 00 00 00
    1dcb:	e9 52 fb ff ff       	jmp    1922 <main+0x562>
    1dd0:	48 c7 44 24 08 08 00 	mov    QWORD PTR [rsp+0x8],0x8
    1dd7:	00 00
    1dd9:	eb 9a                	jmp    1d75 <main+0x9b5>
    1ddb:	48 c7 84 24 50 01 00 	mov    QWORD PTR [rsp+0x150],0x1
    1de2:	00 01 00 00 00
    1de7:	e9 9a f7 ff ff       	jmp    1586 <main+0x1c6>
    1dec:	48 c7 44 24 18 10 00 	mov    QWORD PTR [rsp+0x18],0x10
    1df3:	00 00
    1df5:	e9 f1 fe ff ff       	jmp    1ceb <main+0x92b>
    1dfa:	48 8d 15 ff 17 00 00 	lea    rdx,[rip+0x17ff]        # 3600 <_IO_stdin_used+0x600>
    1e01:	e9 b4 f8 ff ff       	jmp    16ba <main+0x2fa>
    1e06:	48 8d 15 c3 17 00 00 	lea    rdx,[rip+0x17c3]        # 35d0 <_IO_stdin_used+0x5d0>
    1e0d:	e9 a8 f8 ff ff       	jmp    16ba <main+0x2fa>
    1e12:	48 8d 05 11 12 00 00 	lea    rax,[rip+0x1211]        # 302a <_IO_stdin_used+0x2a>
    1e19:	41 bd 40 0d 03 00    	mov    r13d,0x30d40
    1e1f:	4c 8d 3d f1 11 00 00 	lea    r15,[rip+0x11f1]        # 3017 <_IO_stdin_used+0x17>
    1e26:	45 31 e4             	xor    r12d,r12d
    1e29:	48 89 44 24 18       	mov    QWORD PTR [rsp+0x18],rax
    1e2e:	48 8d 05 3b 13 00 00 	lea    rax,[rip+0x133b]        # 3170 <_IO_stdin_used+0x170>
    1e35:	48 c7 84 24 b0 00 00 	mov    QWORD PTR [rsp+0xb0],0x5
    1e3c:	00 05 00 00 00
    1e41:	48 89 44 24 08       	mov    QWORD PTR [rsp+0x8],rax
    1e46:	48 c7 44 24 10 00 00 	mov    QWORD PTR [rsp+0x10],0x0
    1e4d:	00 00
    1e4f:	e9 03 f7 ff ff       	jmp    1557 <main+0x197>
    1e54:	48 8b 3d e5 31 00 00 	mov    rdi,QWORD PTR [rip+0x31e5]        # 5040 <stderr@GLIBC_2.2.5>
    1e5b:	4c 89 f1             	mov    rcx,r14
    1e5e:	be 01 00 00 00       	mov    esi,0x1
    1e63:	31 c0                	xor    eax,eax
    1e65:	48 8d 15 34 17 00 00 	lea    rdx,[rip+0x1734]        # 35a0 <_IO_stdin_used+0x5a0>
    1e6c:	e8 0f f5 ff ff       	call   1380 <__fprintf_chk@plt>
    1e71:	48 8b 7d 00          	mov    rdi,QWORD PTR [rbp+0x0]
    1e75:	e8 e6 10 00 00       	call   2f60 <usage>
    1e7a:	c7 84 24 ac 00 00 00 	mov    DWORD PTR [rsp+0xac],0x2
    1e81:	02 00 00 00
    1e85:	e9 98 fa ff ff       	jmp    1922 <main+0x562>
    1e8a:	e8 f1 f3 ff ff       	call   1280 <__stack_chk_fail@plt>
    1e8f:	4c 8b 7c 24 08       	mov    r15,QWORD PTR [rsp+0x8]
    1e94:	4c 89 c3             	mov    rbx,r8
    1e97:	4c 8b 6c 24 28       	mov    r13,QWORD PTR [rsp+0x28]
    1e9c:	4c 89 a4 24 28 01 00 	mov    QWORD PTR [rsp+0x128],r12
    1ea3:	00
    1ea4:	4c 8b 64 24 40       	mov    r12,QWORD PTR [rsp+0x40]
    1ea9:	4c 89 ff             	mov    rdi,r15
    1eac:	e8 6f f3 ff ff       	call   1220 <free@plt>
    1eb1:	48 85 db             	test   rbx,rbx
    1eb4:	0f 84 69 fe ff ff    	je     1d23 <main+0x963>
    1eba:	48 8b 44 24 30       	mov    rax,QWORD PTR [rsp+0x30]
    1ebf:	48 85 c0             	test   rax,rax
    1ec2:	74 05                	je     1ec9 <main+0xb09>
    1ec4:	80 38 00             	cmp    BYTE PTR [rax],0x0
    1ec7:	75 0c                	jne    1ed5 <main+0xb15>
    1ec9:	48 8d 05 68 11 00 00 	lea    rax,[rip+0x1168]        # 3038 <_IO_stdin_used+0x38>
    1ed0:	48 89 44 24 30       	mov    QWORD PTR [rsp+0x30],rax
    1ed5:	31 ff                	xor    edi,edi
    1ed7:	e8 34 f4 ff ff       	call   1310 <time@plt>
    1edc:	48 8b b4 24 d0 00 00 	mov    rsi,QWORD PTR [rsp+0xd0]
    1ee3:	00
    1ee4:	48 89 ef             	mov    rdi,rbp
    1ee7:	48 89 84 24 58 01 00 	mov    QWORD PTR [rsp+0x158],rax
    1eee:	00
    1eef:	e8 bc f3 ff ff       	call   12b0 <gmtime_r@plt>
    1ef4:	48 85 c0             	test   rax,rax
    1ef7:	74 26                	je     1f1f <main+0xb5f>
    1ef9:	48 8b 8c 24 d0 00 00 	mov    rcx,QWORD PTR [rsp+0xd0]
    1f00:	00
    1f01:	48 8d bc 24 b0 05 00 	lea    rdi,[rsp+0x5b0]
    1f08:	00
    1f09:	be 20 00 00 00       	mov    esi,0x20
    1f0e:	48 8d 15 e3 11 00 00 	lea    rdx,[rip+0x11e3]        # 30f8 <_IO_stdin_used+0xf8>
    1f15:	e8 26 f4 ff ff       	call   1340 <strftime@plt>
    1f1a:	48 85 c0             	test   rax,rax
    1f1d:	75 12                	jne    1f31 <main+0xb71>
    1f1f:	48 b8 75 6e 6b 6e 6f 	movabs rax,0x6e776f6e6b6e75
    1f26:	77 6e 00
    1f29:	48 89 84 24 b0 05 00 	mov    QWORD PTR [rsp+0x5b0],rax
    1f30:	00
    1f31:	e8 2a f4 ff ff       	call   1360 <sched_getcpu@plt>
    1f36:	48 8b 7c 24 38       	mov    rdi,QWORD PTR [rsp+0x38]
    1f3b:	b9 50 00 00 00       	mov    ecx,0x50
    1f40:	89 84 24 a8 00 00 00 	mov    DWORD PTR [rsp+0xa8],eax
    1f47:	31 c0                	xor    eax,eax
    1f49:	f3 48 ab             	rep stos QWORD PTR es:[rdi],rax
    1f4c:	4d 85 e4             	test   r12,r12
    1f4f:	74 07                	je     1f58 <main+0xb98>
    1f51:	41 80 3c 24 00       	cmp    BYTE PTR [r12],0x0
    1f56:	75 20                	jne    1f78 <main+0xbb8>
    1f58:	48 8d 3d ac 11 00 00 	lea    rdi,[rip+0x11ac]        # 310b <_IO_stdin_used+0x10b>
    1f5f:	e8 9c f2 ff ff       	call   1200 <getenv@plt>
    1f64:	49 89 c4             	mov    r12,rax
    1f67:	48 85 c0             	test   rax,rax
    1f6a:	74 05                	je     1f71 <main+0xbb1>
    1f6c:	80 38 00             	cmp    BYTE PTR [rax],0x0
    1f6f:	75 07                	jne    1f78 <main+0xbb8>
    1f71:	4c 8d 25 c7 10 00 00 	lea    r12,[rip+0x10c7]        # 303f <_IO_stdin_used+0x3f>
    1f78:	48 8b 7c 24 38       	mov    rdi,QWORD PTR [rsp+0x38]
    1f7d:	4c 89 e1             	mov    rcx,r12
    1f80:	be 40 00 00 00       	mov    esi,0x40
    1f85:	31 c0                	xor    eax,eax
    1f87:	4c 8d 25 86 10 00 00 	lea    r12,[rip+0x1086]        # 3014 <_IO_stdin_used+0x14>
    1f8e:	4c 89 e2             	mov    rdx,r12
    1f91:	e8 fa f2 ff ff       	call   1290 <snprintf@plt>
    1f96:	48 8d b4 24 70 03 00 	lea    rsi,[rsp+0x370]
    1f9d:	00
    1f9e:	ba 80 00 00 00       	mov    edx,0x80
    1fa3:	48 8d 3d 6c 11 00 00 	lea    rdi,[rip+0x116c]        # 3116 <_IO_stdin_used+0x116>
    1faa:	e8 21 0e 00 00       	call   2dd0 <read_cpuinfo_field>
    1faf:	85 c0                	test   eax,eax
    1fb1:	0f 85 4f 09 00 00    	jne    2906 <main+0x1546>
    1fb7:	48 8d b4 24 f0 03 00 	lea    rsi,[rsp+0x3f0]
    1fbe:	00
    1fbf:	ba 20 00 00 00       	mov    edx,0x20
    1fc4:	48 8d 3d 56 11 00 00 	lea    rdi,[rip+0x1156]        # 3121 <_IO_stdin_used+0x121>
    1fcb:	e8 00 0e 00 00       	call   2dd0 <read_cpuinfo_field>
    1fd0:	85 c0                	test   eax,eax
    1fd2:	0f 85 17 09 00 00    	jne    28ef <main+0x152f>
    1fd8:	48 8d b4 24 10 04 00 	lea    rsi,[rsp+0x410]
    1fdf:	00
    1fe0:	ba 20 00 00 00       	mov    edx,0x20
    1fe5:	48 8d 3d 40 11 00 00 	lea    rdi,[rip+0x1140]        # 312c <_IO_stdin_used+0x12c>
    1fec:	e8 df 0d 00 00       	call   2dd0 <read_cpuinfo_field>
    1ff1:	85 c0                	test   eax,eax
    1ff3:	0f 85 df 08 00 00    	jne    28d8 <main+0x1518>
    1ff9:	48 8d b4 24 30 04 00 	lea    rsi,[rsp+0x430]
    2000:	00
    2001:	ba 20 00 00 00       	mov    edx,0x20
    2006:	48 8d 3d 25 11 00 00 	lea    rdi,[rip+0x1125]        # 3132 <_IO_stdin_used+0x132>
    200d:	e8 be 0d 00 00       	call   2dd0 <read_cpuinfo_field>
    2012:	85 c0                	test   eax,eax
    2014:	0f 85 a7 08 00 00    	jne    28c1 <main+0x1501>
    201a:	48 8d b4 24 50 04 00 	lea    rsi,[rsp+0x450]
    2021:	00
    2022:	ba 20 00 00 00       	mov    edx,0x20
    2027:	48 8d 3d 0d 11 00 00 	lea    rdi,[rip+0x110d]        # 313b <_IO_stdin_used+0x13b>
    202e:	e8 9d 0d 00 00       	call   2dd0 <read_cpuinfo_field>
    2033:	85 c0                	test   eax,eax
    2035:	0f 85 6f 08 00 00    	jne    28aa <main+0x14ea>
    203b:	48 8d 84 24 a0 01 00 	lea    rax,[rsp+0x1a0]
    2042:	00
    2043:	48 89 c7             	mov    rdi,rax
    2046:	48 89 84 24 98 00 00 	mov    QWORD PTR [rsp+0x98],rax
    204d:	00
    204e:	e8 4d f2 ff ff       	call   12a0 <uname@plt>
    2053:	85 c0                	test   eax,eax
    2055:	0f 85 38 08 00 00    	jne    2893 <main+0x14d3>
    205b:	48 8d 8c 24 22 02 00 	lea    rcx,[rsp+0x222]
    2062:	00
    2063:	48 8d bc 24 70 04 00 	lea    rdi,[rsp+0x470]
    206a:	00
    206b:	4c 89 e2             	mov    rdx,r12
    206e:	be 80 00 00 00       	mov    esi,0x80
    2073:	e8 18 f2 ff ff       	call   1290 <snprintf@plt>
    2078:	48 8d 84 24 f0 04 00 	lea    rax,[rsp+0x4f0]
    207f:	00
    2080:	48 8d 35 be 10 00 00 	lea    rsi,[rip+0x10be]        # 3145 <_IO_stdin_used+0x145>
    2087:	b9 07 00 00 00       	mov    ecx,0x7
    208c:	4c 8b 3d 8d 2f 00 00 	mov    r15,QWORD PTR [rip+0x2f8d]        # 5020 <stdout@GLIBC_2.2.5>
    2093:	48 89 c7             	mov    rdi,rax
    2096:	f3 a4                	rep movs BYTE PTR es:[rdi],BYTE PTR ds:[rsi]
    2098:	48 8d bc 24 30 05 00 	lea    rdi,[rsp+0x530]
    209f:	00
    20a0:	48 8d 35 41 16 00 00 	lea    rsi,[rip+0x1641]        # 36e8 <_IO_stdin_used+0x6e8>
    20a7:	b9 16 00 00 00       	mov    ecx,0x16
    20ac:	48 89 7c 24 70       	mov    QWORD PTR [rsp+0x70],rdi
    20b1:	f3 a5                	rep movs DWORD PTR es:[rdi],DWORD PTR ds:[rsi]
    20b3:	48 8b 7c 24 10       	mov    rdi,QWORD PTR [rsp+0x10]
    20b8:	48 85 ff             	test   rdi,rdi
    20bb:	74 14                	je     20d1 <main+0xd11>
    20bd:	48 8d 35 88 10 00 00 	lea    rsi,[rip+0x1088]        # 314c <_IO_stdin_used+0x14c>
    20c4:	e8 37 f2 ff ff       	call   1300 <strcmp@plt>
    20c9:	85 c0                	test   eax,eax
    20cb:	0f 85 4c 08 00 00    	jne    291d <main+0x155d>
    20d1:	4c 89 f9             	mov    rcx,r15
    20d4:	ba be 00 00 00       	mov    edx,0xbe
    20d9:	be 01 00 00 00       	mov    esi,0x1
    20de:	48 8d 3d 7b 16 00 00 	lea    rdi,[rip+0x167b]        # 3760 <_IO_stdin_used+0x760>
    20e5:	e8 86 f2 ff ff       	call   1370 <fwrite@plt>
    20ea:	4a 8d 04 ed 00 00 00 	lea    rax,[r13*8+0x0]
    20f1:	00
    20f2:	48 8b 9c 24 88 00 00 	mov    rbx,QWORD PTR [rsp+0x88]
    20f9:	00
    20fa:	31 d2                	xor    edx,edx
    20fc:	48 89 84 24 20 01 00 	mov    QWORD PTR [rsp+0x120],rax
    2103:	00
    2104:	48 8b 84 24 c0 00 00 	mov    rax,QWORD PTR [rsp+0xc0]
    210b:	00
    210c:	48 b9 2a f8 94 fe 72 	movabs rcx,0x3c6ef372fe94f82a
    2113:	f3 6e 3c
    2116:	48 c7 84 24 00 01 00 	mov    QWORD PTR [rsp+0x100],0x0
    211d:	00 00 00 00 00
    2122:	48 89 44 24 40       	mov    QWORD PTR [rsp+0x40],rax
    2127:	48 b8 2a f8 94 fe 72 	movabs rax,0x3c6ef372fe94f82a
    212e:	f3 6e 3c
    2131:	48 c7 84 24 08 01 00 	mov    QWORD PTR [rsp+0x108],0x0
    2138:	00 00 00 00 00
    213d:	48 0f af c3          	imul   rax,rbx
    2141:	48 29 c8             	sub    rax,rcx
    2144:	48 85 db             	test   rbx,rbx
    2147:	48 0f 44 c2          	cmove  rax,rdx
    214b:	48 01 c8             	add    rax,rcx
    214e:	48 89 84 24 b8 00 00 	mov    QWORD PTR [rsp+0xb8],rax
    2155:	00
    2156:	48 c7 84 24 f8 00 00 	mov    QWORD PTR [rsp+0xf8],0x0
    215d:	00 00 00 00 00
    2162:	4c 89 f8             	mov    rax,r15
    2165:	4d 89 ef             	mov    r15,r13
    2168:	49 89 c5             	mov    r13,rax
    216b:	48 8b 84 24 c8 00 00 	mov    rax,QWORD PTR [rsp+0xc8]
    2172:	00
    2173:	48 8b 9c 24 f8 00 00 	mov    rbx,QWORD PTR [rsp+0xf8]
    217a:	00
    217b:	4c 8b 34 d8          	mov    r14,QWORD PTR [rax+rbx*8]
    217f:	4d 85 f6             	test   r14,r14
    2182:	0f 88 db 06 00 00    	js     2863 <main+0x14a3>
    2188:	48 8b bc 24 d0 00 00 	mov    rdi,QWORD PTR [rsp+0xd0]
    218f:	00
    2190:	4b 8d 1c 36          	lea    rbx,[r14+r14*1]
    2194:	be 40 00 00 00       	mov    esi,0x40
    2199:	48 c7 84 24 60 01 00 	mov    QWORD PTR [rsp+0x160],0x0
    21a0:	00 00 00 00 00
    21a5:	48 89 da             	mov    rdx,rbx
    21a8:	e8 e3 f1 ff ff       	call   1390 <posix_memalign@plt>
    21ad:	89 84 24 ac 00 00 00 	mov    DWORD PTR [rsp+0xac],eax
    21b4:	85 c0                	test   eax,eax
    21b6:	0f 85 77 06 00 00    	jne    2833 <main+0x1473>
    21bc:	48 8b 8c 24 60 01 00 	mov    rcx,QWORD PTR [rsp+0x160]
    21c3:	00
    21c4:	48 85 c9             	test   rcx,rcx
    21c7:	0f 84 66 06 00 00    	je     2833 <main+0x1473>
    21cd:	48 85 db             	test   rbx,rbx
    21d0:	74 20                	je     21f2 <main+0xe32>
    21d2:	ba 07 00 00 00       	mov    edx,0x7
    21d7:	31 c0                	xor    eax,eax
    21d9:	eb 08                	jmp    21e3 <main+0xe23>
    21db:	48 8b 8c 24 60 01 00 	mov    rcx,QWORD PTR [rsp+0x160]
    21e2:	00
    21e3:	88 14 01             	mov    BYTE PTR [rcx+rax*1],dl
    21e6:	48 83 c0 01          	add    rax,0x1
    21ea:	83 ea 7d             	sub    edx,0x7d
    21ed:	48 39 c3             	cmp    rbx,rax
    21f0:	75 e9                	jne    21db <main+0xe1b>
    21f2:	48 8b bc 24 20 01 00 	mov    rdi,QWORD PTR [rsp+0x120]
    21f9:	00
    21fa:	e8 21 f1 ff ff       	call   1320 <malloc@plt>
    21ff:	49 89 c4             	mov    r12,rax
    2202:	48 85 c0             	test   rax,rax
    2205:	0f 84 f1 05 00 00    	je     27fc <main+0x143c>
    220b:	48 8b bc 24 48 01 00 	mov    rdi,QWORD PTR [rsp+0x148]
    2212:	00
    2213:	48 8b 44 24 40       	mov    rax,QWORD PTR [rsp+0x40]
    2218:	45 31 c0             	xor    r8d,r8d
    221b:	31 c9                	xor    ecx,ecx
    221d:	49 bb b9 e5 e4 1c 6d 	movabs r11,0xbf58476d1ce4e5b9
    2224:	47 58 bf
    2227:	48 bb eb 11 31 13 bb 	movabs rbx,0x94d049bb133111eb
    222e:	49 d0 94
    2231:	48 bd 15 7c 4a 7f b9 	movabs rbp,0x9e3779b97f4a7c15
    2238:	79 37 9e
    223b:	48 89 7c 24 48       	mov    QWORD PTR [rsp+0x48],rdi
    2240:	44 8b 50 20          	mov    r10d,DWORD PTR [rax+0x20]
    2244:	48 b8 2a f8 94 fe 72 	movabs rax,0x3c6ef372fe94f82a
    224b:	f3 6e 3c
    224e:	48 89 fe             	mov    rsi,rdi
    2251:	48 01 c7             	add    rdi,rax
    2254:	48 89 fa             	mov    rdx,rdi
    2257:	48 c1 ea 1e          	shr    rdx,0x1e
    225b:	48 31 fa             	xor    rdx,rdi
    225e:	49 0f af d3          	imul   rdx,r11
    2262:	48 89 d0             	mov    rax,rdx
    2265:	48 c1 e8 1b          	shr    rax,0x1b
    2269:	48 31 d0             	xor    rax,rdx
    226c:	48 0f af c3          	imul   rax,rbx
    2270:	48 89 c2             	mov    rdx,rax
    2273:	48 c1 ea 1f          	shr    rdx,0x1f
    2277:	48 31 d0             	xor    rax,rdx
    227a:	31 d2                	xor    edx,edx
    227c:	49 f7 f6             	div    r14
    227f:	49 89 d1             	mov    r9,rdx
    2282:	45 85 d2             	test   r10d,r10d
    2285:	7e 62                	jle    22e9 <main+0xf29>
    2287:	48 01 ee             	add    rsi,rbp
    228a:	48 89 f2             	mov    rdx,rsi
    228d:	48 c1 ea 1e          	shr    rdx,0x1e
    2291:	48 31 f2             	xor    rdx,rsi
    2294:	49 0f af d3          	imul   rdx,r11
    2298:	48 89 d0             	mov    rax,rdx
    229b:	48 c1 e8 1b          	shr    rax,0x1b
    229f:	48 31 d0             	xor    rax,rdx
    22a2:	48 0f af c3          	imul   rax,rbx
    22a6:	48 89 c6             	mov    rsi,rax
    22a9:	48 c1 ee 1f          	shr    rsi,0x1f
    22ad:	48 31 c6             	xor    rsi,rax
    22b0:	48 b8 c3 f5 28 5c 8f 	movabs rax,0x28f5c28f5c28f5c3
    22b7:	c2 f5 28
    22ba:	48 89 f2             	mov    rdx,rsi
    22bd:	48 c1 ea 02          	shr    rdx,0x2
    22c1:	48 f7 e2             	mul    rdx
    22c4:	48 89 d0             	mov    rax,rdx
    22c7:	48 83 e2 fc          	and    rdx,0xfffffffffffffffc
    22cb:	48 c1 e8 02          	shr    rax,0x2
    22cf:	48 01 d0             	add    rax,rdx
    22d2:	48 8d 04 80          	lea    rax,[rax+rax*4]
    22d6:	48 c1 e0 02          	shl    rax,0x2
    22da:	48 29 c6             	sub    rsi,rax
    22dd:	41 39 f2             	cmp    r10d,esi
    22e0:	7e 07                	jle    22e9 <main+0xf29>
    22e2:	48 83 c1 01          	add    rcx,0x1
    22e6:	4d 01 f1             	add    r9,r14
    22e9:	4f 89 0c c4          	mov    QWORD PTR [r12+r8*8],r9
    22ed:	49 83 c0 01          	add    r8,0x1
    22f1:	4d 39 f8             	cmp    r8,r15
    22f4:	0f 82 4a ff ff ff    	jb     2244 <main+0xe84>
    22fa:	66 0f ef ed          	pxor   xmm5,xmm5
    22fe:	f2 49 0f 2a ef       	cvtsi2sd xmm5,r15
    2303:	f2 0f 11 6c 24 50    	movsd  QWORD PTR [rsp+0x50],xmm5
    2309:	48 85 c9             	test   rcx,rcx
    230c:	0f 88 67 04 00 00    	js     2779 <main+0x13b9>
    2312:	66 0f ef c0          	pxor   xmm0,xmm0
    2316:	f2 48 0f 2a c1       	cvtsi2sd xmm0,rcx
    231b:	48 8b 84 24 08 01 00 	mov    rax,QWORD PTR [rsp+0x108]
    2322:	00
    2323:	4c 89 a4 24 90 00 00 	mov    QWORD PTR [rsp+0x90],r12
    232a:	00
    232b:	f2 0f 5e 44 24 50    	divsd  xmm0,QWORD PTR [rsp+0x50]
    2331:	48 c7 84 24 e8 00 00 	mov    QWORD PTR [rsp+0xe8],0x0
    2338:	00 00 00 00 00
    233d:	48 8d 50 01          	lea    rdx,[rax+0x1]
    2341:	f2 0f 11 44 24 60    	movsd  QWORD PTR [rsp+0x60],xmm0
    2347:	48 b8 b9 e5 e4 1c 6d 	movabs rax,0xbf58476d1ce4e5b9
    234e:	47 58 bf
    2351:	48 0f af d0          	imul   rdx,rax
    2355:	48 8d 84 24 b0 05 00 	lea    rax,[rsp+0x5b0]
    235c:	00
    235d:	48 89 44 24 78       	mov    QWORD PTR [rsp+0x78],rax
    2362:	48 8d 84 24 ac 01 00 	lea    rax,[rsp+0x1ac]
    2369:	00
    236a:	48 89 44 24 68       	mov    QWORD PTR [rsp+0x68],rax
    236f:	4c 89 f0             	mov    rax,r14
    2372:	4d 89 ee             	mov    r14,r13
    2375:	48 89 94 24 18 01 00 	mov    QWORD PTR [rsp+0x118],rdx
    237c:	00
    237d:	49 89 c5             	mov    r13,rax
    2380:	48 8b 84 24 d8 00 00 	mov    rax,QWORD PTR [rsp+0xd8]
    2387:	00
    2388:	48 8b 9c 24 e8 00 00 	mov    rbx,QWORD PTR [rsp+0xe8]
    238f:	00
    2390:	48 b9 15 7c 4a 7f b9 	movabs rcx,0x9e3779b97f4a7c15
    2397:	79 37 9e
    239a:	48 c7 44 24 28 00 00 	mov    QWORD PTR [rsp+0x28],0x0
    23a1:	00 00
    23a3:	48 8b 1c d8          	mov    rbx,QWORD PTR [rax+rbx*8]
    23a7:	48 8b 44 24 48       	mov    rax,QWORD PTR [rsp+0x48]
    23ac:	48 33 84 24 18 01 00 	xor    rax,QWORD PTR [rsp+0x118]
    23b3:	00
    23b4:	48 31 c1             	xor    rcx,rax
    23b7:	48 89 5c 24 58       	mov    QWORD PTR [rsp+0x58],rbx
    23bc:	48 89 8c 24 a0 00 00 	mov    QWORD PTR [rsp+0xa0],rcx
    23c3:	00
    23c4:	89 5c 24 10          	mov    DWORD PTR [rsp+0x10],ebx
    23c8:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
    23cf:	00
    23d0:	48 8b 84 24 a0 00 00 	mov    rax,QWORD PTR [rsp+0xa0]
    23d7:	00
    23d8:	48 c7 44 24 08 00 00 	mov    QWORD PTR [rsp+0x8],0x0
    23df:	00 00
    23e1:	48 89 84 24 80 00 00 	mov    QWORD PTR [rsp+0x80],rax
    23e8:	00
    23e9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    23f0:	48 8b 9c 24 80 00 00 	mov    rbx,QWORD PTR [rsp+0x80]
    23f7:	00
    23f8:	48 b8 00 00 00 00 01 	movabs rax,0x100000000
    23ff:	00 00 00
    2402:	48 bf b9 e5 e4 1c 6d 	movabs rdi,0xbf58476d1ce4e5b9
    2409:	47 58 bf
    240c:	49 bb eb 11 31 13 bb 	movabs r11,0x94d049bb133111eb
    2413:	49 d0 94
    2416:	48 89 84 24 a0 01 00 	mov    QWORD PTR [rsp+0x1a0],rax
    241d:	00
    241e:	48 b8 15 7c 4a 7f b9 	movabs rax,0x9e3779b97f4a7c15
    2425:	79 37 9e
    2428:	48 8b b4 24 98 00 00 	mov    rsi,QWORD PTR [rsp+0x98]
    242f:	00
    2430:	c7 84 24 a8 01 00 00 	mov    DWORD PTR [rsp+0x1a8],0x2
    2437:	02 00 00 00
    243b:	48 01 d8             	add    rax,rbx
    243e:	48 89 c2             	mov    rdx,rax
    2441:	49 89 f4             	mov    r12,rsi
    2444:	48 c1 ea 1e          	shr    rdx,0x1e
    2448:	48 31 c2             	xor    rdx,rax
    244b:	48 0f af d7          	imul   rdx,rdi
    244f:	48 89 d0             	mov    rax,rdx
    2452:	48 c1 e8 1b          	shr    rax,0x1b
    2456:	48 31 d0             	xor    rax,rdx
    2459:	48 ba ab aa aa aa aa 	movabs rdx,0xaaaaaaaaaaaaaaab
    2460:	aa aa aa
    2463:	49 0f af c3          	imul   rax,r11
    2467:	48 89 c1             	mov    rcx,rax
    246a:	48 c1 e9 1f          	shr    rcx,0x1f
    246e:	48 31 c1             	xor    rcx,rax
    2471:	48 89 c8             	mov    rax,rcx
    2474:	48 f7 e2             	mul    rdx
    2477:	48 89 d0             	mov    rax,rdx
    247a:	48 83 e2 fe          	and    rdx,0xfffffffffffffffe
    247e:	48 d1 e8             	shr    rax,1
    2481:	48 01 c2             	add    rdx,rax
    2484:	48 29 d1             	sub    rcx,rdx
    2487:	48 8d 04 8e          	lea    rax,[rsi+rcx*4]
    248b:	8b 10                	mov    edx,DWORD PTR [rax]
    248d:	89 94 24 a8 01 00 00 	mov    DWORD PTR [rsp+0x1a8],edx
    2494:	c7 00 02 00 00 00    	mov    DWORD PTR [rax],0x2
    249a:	8b 8c 24 a4 01 00 00 	mov    ecx,DWORD PTR [rsp+0x1a4]
    24a1:	48 b8 2a f8 94 fe 72 	movabs rax,0x3c6ef372fe94f82a
    24a8:	f3 6e 3c
    24ab:	48 01 c3             	add    rbx,rax
    24ae:	48 89 da             	mov    rdx,rbx
    24b1:	48 89 9c 24 80 00 00 	mov    QWORD PTR [rsp+0x80],rbx
    24b8:	00
    24b9:	48 c1 ea 1e          	shr    rdx,0x1e
    24bd:	48 31 da             	xor    rdx,rbx
    24c0:	48 8b 9c 24 90 00 00 	mov    rbx,QWORD PTR [rsp+0x90]
    24c7:	00
    24c8:	48 0f af d7          	imul   rdx,rdi
    24cc:	48 89 d0             	mov    rax,rdx
    24cf:	48 c1 e8 1b          	shr    rax,0x1b
    24d3:	48 31 d0             	xor    rax,rdx
    24d6:	49 0f af c3          	imul   rax,r11
    24da:	48 89 c2             	mov    rdx,rax
    24dd:	48 c1 ea 1f          	shr    rdx,0x1f
    24e1:	48 31 d0             	xor    rax,rdx
    24e4:	83 e0 01             	and    eax,0x1
    24e7:	48 8d 04 86          	lea    rax,[rsi+rax*4]
    24eb:	8b 10                	mov    edx,DWORD PTR [rax]
    24ed:	89 94 24 a4 01 00 00 	mov    DWORD PTR [rsp+0x1a4],edx
    24f4:	89 08                	mov    DWORD PTR [rax],ecx
    24f6:	49 63 2c 24          	movsxd rbp,DWORD PTR [r12]
    24fa:	44 8b 44 24 10       	mov    r8d,DWORD PTR [rsp+0x10]
    24ff:	4c 89 e9             	mov    rcx,r13
    2502:	48 89 de             	mov    rsi,rbx
    2505:	48 8b 94 24 50 01 00 	mov    rdx,QWORD PTR [rsp+0x150]
    250c:	00
    250d:	48 8d 05 8c 27 00 00 	lea    rax,[rip+0x278c]        # 4ca0 <run_variant>
    2514:	48 8b bc 24 60 01 00 	mov    rdi,QWORD PTR [rsp+0x160]
    251b:	00
    251c:	4c 8b 0c e8          	mov    r9,QWORD PTR [rax+rbp*8]
    2520:	49 39 d7             	cmp    r15,rdx
    2523:	4c 89 4c 24 20       	mov    QWORD PTR [rsp+0x20],r9
    2528:	49 0f 46 d7          	cmovbe rdx,r15
    252c:	41 ff d1             	call   r9
    252f:	48 8b bc 24 60 01 00 	mov    rdi,QWORD PTR [rsp+0x160]
    2536:	00
    2537:	0f ae e8             	lfence
    253a:	0f 01 f9             	rdtscp
    253d:	89 c0                	mov    eax,eax
    253f:	48 c1 e2 20          	shl    rdx,0x20
    2543:	44 8b 44 24 10       	mov    r8d,DWORD PTR [rsp+0x10]
    2548:	4c 8b 4c 24 20       	mov    r9,QWORD PTR [rsp+0x20]
    254d:	48 09 c2             	or     rdx,rax
    2550:	4c 89 e9             	mov    rcx,r13
    2553:	48 89 de             	mov    rsi,rbx
    2556:	48 89 54 24 18       	mov    QWORD PTR [rsp+0x18],rdx
    255b:	4c 89 fa             	mov    rdx,r15
    255e:	41 ff d1             	call   r9
    2561:	0f ae e8             	lfence
    2564:	0f 01 f9             	rdtscp
    2567:	49 89 d0             	mov    r8,rdx
    256a:	89 c0                	mov    eax,eax
    256c:	49 c1 e0 20          	shl    r8,0x20
    2570:	49 09 c0             	or     r8,rax
    2573:	4c 2b 44 24 18       	sub    r8,QWORD PTR [rsp+0x18]
    2578:	0f 88 da 01 00 00    	js     2758 <main+0x1398>
    257e:	66 0f ef c9          	pxor   xmm1,xmm1
    2582:	f2 49 0f 2a c8       	cvtsi2sd xmm1,r8
    2587:	48 8b 74 24 38       	mov    rsi,QWORD PTR [rsp+0x38]
    258c:	4c 89 f7             	mov    rdi,r14
    258f:	48 c1 e5 04          	shl    rbp,0x4
    2593:	49 83 c4 04          	add    r12,0x4
    2597:	f2 0f 5e 4c 24 50    	divsd  xmm1,QWORD PTR [rsp+0x50]
    259d:	4c 89 44 24 20       	mov    QWORD PTR [rsp+0x20],r8
    25a2:	f2 0f 11 4c 24 18    	movsd  QWORD PTR [rsp+0x18],xmm1
    25a8:	e8 f3 06 00 00       	call   2ca0 <csv_write_quoted>
    25ad:	4c 89 f6             	mov    rsi,r14
    25b0:	bf 2c 00 00 00       	mov    edi,0x2c
    25b5:	e8 06 ed ff ff       	call   12c0 <fputc@plt>
    25ba:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
    25bf:	4c 89 f7             	mov    rdi,r14
    25c2:	e8 d9 06 00 00       	call   2ca0 <csv_write_quoted>
    25c7:	4c 89 f6             	mov    rsi,r14
    25ca:	bf 2c 00 00 00       	mov    edi,0x2c
    25cf:	e8 ec ec ff ff       	call   12c0 <fputc@plt>
    25d4:	48 8b 74 24 78       	mov    rsi,QWORD PTR [rsp+0x78]
    25d9:	4c 89 f7             	mov    rdi,r14
    25dc:	e8 bf 06 00 00       	call   2ca0 <csv_write_quoted>
    25e1:	48 8d 05 d8 26 00 00 	lea    rax,[rip+0x26d8]        # 4cc0 <variants>
    25e8:	be 01 00 00 00       	mov    esi,0x1
    25ed:	4c 89 f7             	mov    rdi,r14
    25f0:	48 8b 0c 28          	mov    rcx,QWORD PTR [rax+rbp*1]
    25f4:	48 8d 15 55 0b 00 00 	lea    rdx,[rip+0xb55]        # 3150 <_IO_stdin_used+0x150>
    25fb:	31 c0                	xor    eax,eax
    25fd:	e8 7e ed ff ff       	call   1380 <__fprintf_chk@plt>
    2602:	48 8b 74 24 70       	mov    rsi,QWORD PTR [rsp+0x70]
    2607:	4c 89 f7             	mov    rdi,r14
    260a:	e8 91 06 00 00       	call   2ca0 <csv_write_quoted>
    260f:	4d 89 e9             	mov    r9,r13
    2612:	be 01 00 00 00       	mov    esi,0x1
    2617:	4c 89 f7             	mov    rdi,r14
    261a:	8b 84 24 a8 00 00 00 	mov    eax,DWORD PTR [rsp+0xa8]
    2621:	48 8d 15 78 12 00 00 	lea    rdx,[rip+0x1278]        # 38a0 <_IO_stdin_used+0x8a0>
    2628:	50                   	push   rax
    2629:	b8 02 00 00 00       	mov    eax,0x2
    262e:	ff 74 24 50          	push   QWORD PTR [rsp+0x50]
    2632:	4c 8b 44 24 30       	mov    r8,QWORD PTR [rsp+0x30]
    2637:	41 50                	push   r8
    2639:	ff 74 24 40          	push   QWORD PTR [rsp+0x40]
    263d:	ff 74 24 28          	push   QWORD PTR [rsp+0x28]
    2641:	41 57                	push   r15
    2643:	f2 0f 10 4c 24 48    	movsd  xmm1,QWORD PTR [rsp+0x48]
    2649:	4c 8b 44 24 70       	mov    r8,QWORD PTR [rsp+0x70]
    264e:	f2 0f 10 84 24 90 00 	movsd  xmm0,QWORD PTR [rsp+0x90]
    2655:	00 00
    2657:	48 8b 8c 24 88 00 00 	mov    rcx,QWORD PTR [rsp+0x88]
    265e:	00
    265f:	e8 1c ed ff ff       	call   1380 <__fprintf_chk@plt>
    2664:	48 83 c4 30          	add    rsp,0x30
    2668:	4c 39 64 24 68       	cmp    QWORD PTR [rsp+0x68],r12
    266d:	0f 85 83 fe ff ff    	jne    24f6 <main+0x1136>
    2673:	48 83 44 24 08 01    	add    QWORD PTR [rsp+0x8],0x1
    2679:	48 8b 44 24 08       	mov    rax,QWORD PTR [rsp+0x8]
    267e:	48 39 84 24 88 00 00 	cmp    QWORD PTR [rsp+0x88],rax
    2685:	00
    2686:	0f 87 64 fd ff ff    	ja     23f0 <main+0x1030>
    268c:	48 83 44 24 28 01    	add    QWORD PTR [rsp+0x28],0x1
    2692:	48 8b 9c 24 b8 00 00 	mov    rbx,QWORD PTR [rsp+0xb8]
    2699:	00
    269a:	48 8b 44 24 28       	mov    rax,QWORD PTR [rsp+0x28]
    269f:	48 01 9c 24 a0 00 00 	add    QWORD PTR [rsp+0xa0],rbx
    26a6:	00
    26a7:	48 3b 84 24 b0 00 00 	cmp    rax,QWORD PTR [rsp+0xb0]
    26ae:	00
    26af:	0f 82 1b fd ff ff    	jb     23d0 <main+0x1010>
    26b5:	48 83 84 24 e8 00 00 	add    QWORD PTR [rsp+0xe8],0x1
    26bc:	00 01
    26be:	48 b8 b9 e5 e4 1c 6d 	movabs rax,0xbf58476d1ce4e5b9
    26c5:	47 58 bf
    26c8:	48 8b 9c 24 e8 00 00 	mov    rbx,QWORD PTR [rsp+0xe8]
    26cf:	00
    26d0:	48 01 84 24 18 01 00 	add    QWORD PTR [rsp+0x118],rax
    26d7:	00
    26d8:	48 3b 9c 24 f0 00 00 	cmp    rbx,QWORD PTR [rsp+0xf0]
    26df:	00
    26e0:	0f 82 9a fc ff ff    	jb     2380 <main+0xfc0>
    26e6:	48 8b 9c 24 08 01 00 	mov    rbx,QWORD PTR [rsp+0x108]
    26ed:	00
    26ee:	4c 8b a4 24 90 00 00 	mov    r12,QWORD PTR [rsp+0x90]
    26f5:	00
    26f6:	31 c0                	xor    eax,eax
    26f8:	4d 89 f5             	mov    r13,r14
    26fb:	48 83 bc 24 f0 00 00 	cmp    QWORD PTR [rsp+0xf0],0x0
    2702:	00 00
    2704:	48 0f 45 84 24 e0 00 	cmovne rax,QWORD PTR [rsp+0xe0]
    270b:	00 00
    270d:	4c 89 e7             	mov    rdi,r12
    2710:	48 8d 44 03 01       	lea    rax,[rbx+rax*1+0x1]
    2715:	48 89 84 24 08 01 00 	mov    QWORD PTR [rsp+0x108],rax
    271c:	00
    271d:	e8 fe ea ff ff       	call   1220 <free@plt>
    2722:	48 8b bc 24 60 01 00 	mov    rdi,QWORD PTR [rsp+0x160]
    2729:	00
    272a:	e8 f1 ea ff ff       	call   1220 <free@plt>
    272f:	48 8b 9c 24 f8 00 00 	mov    rbx,QWORD PTR [rsp+0xf8]
    2736:	00
    2737:	48 8d 43 01          	lea    rax,[rbx+0x1]
    273b:	48 3b 9c 24 28 01 00 	cmp    rbx,QWORD PTR [rsp+0x128]
    2742:	00
    2743:	74 52                	je     2797 <main+0x13d7>
    2745:	48 89 84 24 f8 00 00 	mov    QWORD PTR [rsp+0xf8],rax
    274c:	00
    274d:	e9 19 fa ff ff       	jmp    216b <main+0xdab>
    2752:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    2758:	4c 89 c0             	mov    rax,r8
    275b:	4c 89 c2             	mov    rdx,r8
    275e:	66 0f ef c9          	pxor   xmm1,xmm1
    2762:	48 d1 e8             	shr    rax,1
    2765:	83 e2 01             	and    edx,0x1
    2768:	48 09 d0             	or     rax,rdx
    276b:	f2 48 0f 2a c8       	cvtsi2sd xmm1,rax
    2770:	f2 0f 58 c9          	addsd  xmm1,xmm1
    2774:	e9 0e fe ff ff       	jmp    2587 <main+0x11c7>
    2779:	48 89 c8             	mov    rax,rcx
    277c:	83 e1 01             	and    ecx,0x1
    277f:	66 0f ef c0          	pxor   xmm0,xmm0
    2783:	48 d1 e8             	shr    rax,1
    2786:	48 09 c8             	or     rax,rcx
    2789:	f2 48 0f 2a c0       	cvtsi2sd xmm0,rax
    278e:	f2 0f 58 c0          	addsd  xmm0,xmm0
    2792:	e9 84 fb ff ff       	jmp    231b <main+0xf5b>
    2797:	48 83 84 24 00 01 00 	add    QWORD PTR [rsp+0x100],0x1
    279e:	00 01
    27a0:	4d 87 fd             	xchg   r13,r15
    27a3:	48 8b 84 24 00 01 00 	mov    rax,QWORD PTR [rsp+0x100]
    27aa:	00
    27ab:	48 83 44 24 40 24    	add    QWORD PTR [rsp+0x40],0x24
    27b1:	48 3b 84 24 10 01 00 	cmp    rax,QWORD PTR [rsp+0x110]
    27b8:	00
    27b9:	0f 82 97 f9 ff ff    	jb     2156 <main+0xd96>
    27bf:	4c 39 3d 5a 28 00 00 	cmp    QWORD PTR [rip+0x285a],r15        # 5020 <stdout@GLIBC_2.2.5>
    27c6:	74 08                	je     27d0 <main+0x1410>
    27c8:	4c 89 ff             	mov    rdi,r15
    27cb:	e8 90 ea ff ff       	call   1260 <fclose@plt>
    27d0:	48 8b bc 24 d8 00 00 	mov    rdi,QWORD PTR [rsp+0xd8]
    27d7:	00
    27d8:	e8 43 ea ff ff       	call   1220 <free@plt>
    27dd:	48 8b bc 24 c0 00 00 	mov    rdi,QWORD PTR [rsp+0xc0]
    27e4:	00
    27e5:	e8 36 ea ff ff       	call   1220 <free@plt>
    27ea:	48 8b bc 24 c8 00 00 	mov    rdi,QWORD PTR [rsp+0xc8]
    27f1:	00
    27f2:	e8 29 ea ff ff       	call   1220 <free@plt>
    27f7:	e9 26 f1 ff ff       	jmp    1922 <main+0x562>
    27fc:	48 8b 3d 3d 28 00 00 	mov    rdi,QWORD PTR [rip+0x283d]        # 5040 <stderr@GLIBC_2.2.5>
    2803:	48 8d 15 66 10 00 00 	lea    rdx,[rip+0x1066]        # 3870 <_IO_stdin_used+0x870>
    280a:	be 01 00 00 00       	mov    esi,0x1
    280f:	31 c0                	xor    eax,eax
    2811:	4d 89 ef             	mov    r15,r13
    2814:	e8 67 eb ff ff       	call   1380 <__fprintf_chk@plt>
    2819:	48 8b bc 24 60 01 00 	mov    rdi,QWORD PTR [rsp+0x160]
    2820:	00
    2821:	e8 fa e9 ff ff       	call   1220 <free@plt>
    2826:	c7 84 24 ac 00 00 00 	mov    DWORD PTR [rsp+0xac],0x1
    282d:	01 00 00 00
    2831:	eb 8c                	jmp    27bf <main+0x13ff>
    2833:	48 8b 3d 06 28 00 00 	mov    rdi,QWORD PTR [rip+0x2806]        # 5040 <stderr@GLIBC_2.2.5>
    283a:	48 89 d9             	mov    rcx,rbx
    283d:	31 c0                	xor    eax,eax
    283f:	4d 89 ef             	mov    r15,r13
    2842:	48 8d 15 ff 0f 00 00 	lea    rdx,[rip+0xfff]        # 3848 <_IO_stdin_used+0x848>
    2849:	be 01 00 00 00       	mov    esi,0x1
    284e:	e8 2d eb ff ff       	call   1380 <__fprintf_chk@plt>
    2853:	c7 84 24 ac 00 00 00 	mov    DWORD PTR [rsp+0xac],0x1
    285a:	01 00 00 00
    285e:	e9 5c ff ff ff       	jmp    27bf <main+0x13ff>
    2863:	48 8b 3d d6 27 00 00 	mov    rdi,QWORD PTR [rip+0x27d6]        # 5040 <stderr@GLIBC_2.2.5>
    286a:	4c 89 f1             	mov    rcx,r14
    286d:	31 c0                	xor    eax,eax
    286f:	4d 89 ef             	mov    r15,r13
    2872:	48 8d 15 a7 0f 00 00 	lea    rdx,[rip+0xfa7]        # 3820 <_IO_stdin_used+0x820>
    2879:	be 01 00 00 00       	mov    esi,0x1
    287e:	e8 fd ea ff ff       	call   1380 <__fprintf_chk@plt>
    2883:	c7 84 24 ac 00 00 00 	mov    DWORD PTR [rsp+0xac],0x2
    288a:	02 00 00 00
    288e:	e9 2c ff ff ff       	jmp    27bf <main+0x13ff>
    2893:	48 b8 75 6e 6b 6e 6f 	movabs rax,0x6e776f6e6b6e75
    289a:	77 6e 00
    289d:	48 89 84 24 70 04 00 	mov    QWORD PTR [rsp+0x470],rax
    28a4:	00
    28a5:	e9 ce f7 ff ff       	jmp    2078 <main+0xcb8>
    28aa:	48 b8 75 6e 6b 6e 6f 	movabs rax,0x6e776f6e6b6e75
    28b1:	77 6e 00
    28b4:	48 89 84 24 50 04 00 	mov    QWORD PTR [rsp+0x450],rax
    28bb:	00
    28bc:	e9 7a f7 ff ff       	jmp    203b <main+0xc7b>
    28c1:	48 b8 75 6e 6b 6e 6f 	movabs rax,0x6e776f6e6b6e75
    28c8:	77 6e 00
    28cb:	48 89 84 24 30 04 00 	mov    QWORD PTR [rsp+0x430],rax
    28d2:	00
    28d3:	e9 42 f7 ff ff       	jmp    201a <main+0xc5a>
    28d8:	48 b8 75 6e 6b 6e 6f 	movabs rax,0x6e776f6e6b6e75
    28df:	77 6e 00
    28e2:	48 89 84 24 10 04 00 	mov    QWORD PTR [rsp+0x410],rax
    28e9:	00
    28ea:	e9 0a f7 ff ff       	jmp    1ff9 <main+0xc39>
    28ef:	48 b8 75 6e 6b 6e 6f 	movabs rax,0x6e776f6e6b6e75
    28f6:	77 6e 00
    28f9:	48 89 84 24 f0 03 00 	mov    QWORD PTR [rsp+0x3f0],rax
    2900:	00
    2901:	e9 d2 f6 ff ff       	jmp    1fd8 <main+0xc18>
    2906:	48 b8 75 6e 6b 6e 6f 	movabs rax,0x6e776f6e6b6e75
    290d:	77 6e 00
    2910:	48 89 84 24 70 03 00 	mov    QWORD PTR [rsp+0x370],rax
    2917:	00
    2918:	e9 9a f6 ff ff       	jmp    1fb7 <main+0xbf7>
    291d:	48 8b 7c 24 10       	mov    rdi,QWORD PTR [rsp+0x10]
    2922:	48 8d 35 25 08 00 00 	lea    rsi,[rip+0x825]        # 314e <_IO_stdin_used+0x14e>
    2929:	e8 22 ea ff ff       	call   1350 <fopen@plt>
    292e:	49 89 c7             	mov    r15,rax
    2931:	48 85 c0             	test   rax,rax
    2934:	0f 85 97 f7 ff ff    	jne    20d1 <main+0xd11>
    293a:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
    293f:	8b 38                	mov    edi,DWORD PTR [rax]
    2941:	e8 6a ea ff ff       	call   13b0 <strerror@plt>
    2946:	48 8b 4c 24 10       	mov    rcx,QWORD PTR [rsp+0x10]
    294b:	be 01 00 00 00       	mov    esi,0x1
    2950:	48 8b 3d e9 26 00 00 	mov    rdi,QWORD PTR [rip+0x26e9]        # 5040 <stderr@GLIBC_2.2.5>
    2957:	49 89 c0             	mov    r8,rax
    295a:	48 8d 15 df 0d 00 00 	lea    rdx,[rip+0xddf]        # 3740 <_IO_stdin_used+0x740>
    2961:	31 c0                	xor    eax,eax
    2963:	e8 18 ea ff ff       	call   1380 <__fprintf_chk@plt>
    2968:	48 8b bc 24 d8 00 00 	mov    rdi,QWORD PTR [rsp+0xd8]
    296f:	00
    2970:	e8 ab e8 ff ff       	call   1220 <free@plt>
    2975:	48 8b bc 24 c0 00 00 	mov    rdi,QWORD PTR [rsp+0xc0]
    297c:	00
    297d:	e8 9e e8 ff ff       	call   1220 <free@plt>
    2982:	48 8b bc 24 c8 00 00 	mov    rdi,QWORD PTR [rsp+0xc8]
    2989:	00
    298a:	e8 91 e8 ff ff       	call   1220 <free@plt>
    298f:	c7 84 24 ac 00 00 00 	mov    DWORD PTR [rsp+0xac],0x1
    2996:	01 00 00 00
    299a:	e9 83 ef ff ff       	jmp    1922 <main+0x562>
    299f:	4c 89 ff             	mov    rdi,r15
    29a2:	e8 79 e8 ff ff       	call   1220 <free@plt>
    29a7:	e9 ed f3 ff ff       	jmp    1d99 <main+0x9d9>
    29ac:	48 8d 35 3d 07 00 00 	lea    rsi,[rip+0x73d]        # 30f0 <_IO_stdin_used+0xf0>
    29b3:	4c 89 ef             	mov    rdi,r13
    29b6:	e8 75 e8 ff ff       	call   1230 <strcasecmp@plt>
    29bb:	85 c0                	test   eax,eax
    29bd:	0f 84 a5 f2 ff ff    	je     1c68 <main+0x8a8>
    29c3:	48 8d 35 6f 07 00 00 	lea    rsi,[rip+0x76f]        # 3139 <_IO_stdin_used+0x139>
    29ca:	4c 89 ef             	mov    rdi,r13
    29cd:	e8 5e e8 ff ff       	call   1230 <strcasecmp@plt>
    29d2:	85 c0                	test   eax,eax
    29d4:	74 17                	je     29ed <main+0x162d>
    29d6:	48 8d 35 17 07 00 00 	lea    rsi,[rip+0x717]        # 30f4 <_IO_stdin_used+0xf4>
    29dd:	4c 89 ef             	mov    rdi,r13
    29e0:	e8 4b e8 ff ff       	call   1230 <strcasecmp@plt>
    29e5:	85 c0                	test   eax,eax
    29e7:	0f 85 29 f3 ff ff    	jne    1d16 <main+0x956>
    29ed:	b9 00 00 00 40       	mov    ecx,0x40000000
    29f2:	e9 76 f2 ff ff       	jmp    1c6d <main+0x8ad>
    29f7:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
    29fe:	00 00

0000000000002a00 <_start>:
    2a00:	f3 0f 1e fa          	endbr64
    2a04:	31 ed                	xor    ebp,ebp
    2a06:	49 89 d1             	mov    r9,rdx
    2a09:	5e                   	pop    rsi
    2a0a:	48 89 e2             	mov    rdx,rsp
    2a0d:	48 83 e4 f0          	and    rsp,0xfffffffffffffff0
    2a11:	50                   	push   rax
    2a12:	54                   	push   rsp
    2a13:	45 31 c0             	xor    r8d,r8d
    2a16:	31 c9                	xor    ecx,ecx
    2a18:	48 8d 3d a1 e9 ff ff 	lea    rdi,[rip+0xffffffffffffe9a1]        # 13c0 <main>
    2a1f:	ff 15 b3 25 00 00    	call   QWORD PTR [rip+0x25b3]        # 4fd8 <__libc_start_main@GLIBC_2.34>
    2a25:	f4                   	hlt
    2a26:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    2a2d:	00 00 00

0000000000002a30 <deregister_tm_clones>:
    2a30:	48 8d 3d d9 25 00 00 	lea    rdi,[rip+0x25d9]        # 5010 <__TMC_END__>
    2a37:	48 8d 05 d2 25 00 00 	lea    rax,[rip+0x25d2]        # 5010 <__TMC_END__>
    2a3e:	48 39 f8             	cmp    rax,rdi
    2a41:	74 15                	je     2a58 <deregister_tm_clones+0x28>
    2a43:	48 8b 05 96 25 00 00 	mov    rax,QWORD PTR [rip+0x2596]        # 4fe0 <_ITM_deregisterTMCloneTable@Base>
    2a4a:	48 85 c0             	test   rax,rax
    2a4d:	74 09                	je     2a58 <deregister_tm_clones+0x28>
    2a4f:	ff e0                	jmp    rax
    2a51:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    2a58:	c3                   	ret
    2a59:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000002a60 <register_tm_clones>:
    2a60:	48 8d 3d a9 25 00 00 	lea    rdi,[rip+0x25a9]        # 5010 <__TMC_END__>
    2a67:	48 8d 35 a2 25 00 00 	lea    rsi,[rip+0x25a2]        # 5010 <__TMC_END__>
    2a6e:	48 29 fe             	sub    rsi,rdi
    2a71:	48 89 f0             	mov    rax,rsi
    2a74:	48 c1 ee 3f          	shr    rsi,0x3f
    2a78:	48 c1 f8 03          	sar    rax,0x3
    2a7c:	48 01 c6             	add    rsi,rax
    2a7f:	48 d1 fe             	sar    rsi,1
    2a82:	74 14                	je     2a98 <register_tm_clones+0x38>
    2a84:	48 8b 05 65 25 00 00 	mov    rax,QWORD PTR [rip+0x2565]        # 4ff0 <_ITM_registerTMCloneTable@Base>
    2a8b:	48 85 c0             	test   rax,rax
    2a8e:	74 08                	je     2a98 <register_tm_clones+0x38>
    2a90:	ff e0                	jmp    rax
    2a92:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    2a98:	c3                   	ret
    2a99:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000002aa0 <__do_global_dtors_aux>:
    2aa0:	f3 0f 1e fa          	endbr64
    2aa4:	80 3d 9d 25 00 00 00 	cmp    BYTE PTR [rip+0x259d],0x0        # 5048 <completed.0>
    2aab:	75 2b                	jne    2ad8 <__do_global_dtors_aux+0x38>
    2aad:	55                   	push   rbp
    2aae:	48 83 3d 42 25 00 00 	cmp    QWORD PTR [rip+0x2542],0x0        # 4ff8 <__cxa_finalize@GLIBC_2.2.5>
    2ab5:	00
    2ab6:	48 89 e5             	mov    rbp,rsp
    2ab9:	74 0c                	je     2ac7 <__do_global_dtors_aux+0x27>
    2abb:	48 8b 3d 46 25 00 00 	mov    rdi,QWORD PTR [rip+0x2546]        # 5008 <__dso_handle>
    2ac2:	e8 29 e7 ff ff       	call   11f0 <__cxa_finalize@plt>
    2ac7:	e8 64 ff ff ff       	call   2a30 <deregister_tm_clones>
    2acc:	c6 05 75 25 00 00 01 	mov    BYTE PTR [rip+0x2575],0x1        # 5048 <completed.0>
    2ad3:	5d                   	pop    rbp
    2ad4:	c3                   	ret
    2ad5:	0f 1f 00             	nop    DWORD PTR [rax]
    2ad8:	c3                   	ret
    2ad9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000002ae0 <frame_dummy>:
    2ae0:	f3 0f 1e fa          	endbr64
    2ae4:	e9 77 ff ff ff       	jmp    2a60 <register_tm_clones>
    2ae9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000002af0 <load_baseline>:
    2af0:	f3 0f 1e fa          	endbr64
    2af4:	48 39 d6             	cmp    rsi,rdx
    2af7:	72 07                	jb     2b00 <load_baseline+0x10>
    2af9:	31 c0                	xor    eax,eax
    2afb:	c3                   	ret
    2afc:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
    2b00:	0f b6 04 37          	movzx  eax,BYTE PTR [rdi+rsi*1]
    2b04:	c3                   	ret
    2b05:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
    2b0c:	00 00 00 00

0000000000002b10 <load_lfence>:
    2b10:	f3 0f 1e fa          	endbr64
    2b14:	48 39 d6             	cmp    rsi,rdx
    2b17:	72 07                	jb     2b20 <load_lfence+0x10>
    2b19:	31 c0                	xor    eax,eax
    2b1b:	c3                   	ret
    2b1c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
    2b20:	0f ae e8             	lfence
    2b23:	0f b6 04 37          	movzx  eax,BYTE PTR [rdi+rsi*1]
    2b27:	c3                   	ret
    2b28:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
    2b2f:	00

0000000000002b30 <load_mask>:
    2b30:	f3 0f 1e fa          	endbr64
    2b34:	48 39 d6             	cmp    rsi,rdx
    2b37:	48 19 c0             	sbb    rax,rax
    2b3a:	48 21 f0             	and    rax,rsi
    2b3d:	0f b6 04 07          	movzx  eax,BYTE PTR [rdi+rax*1]
    2b41:	c3                   	ret
    2b42:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
    2b49:	00 00 00 00
    2b4d:	0f 1f 00             	nop    DWORD PTR [rax]

0000000000002b50 <run_baseline>:
    2b50:	f3 0f 1e fa          	endbr64
    2b54:	49 89 c9             	mov    r9,rcx
    2b57:	48 85 d2             	test   rdx,rdx
    2b5a:	74 57                	je     2bb3 <run_baseline+0x63>
    2b5c:	48 89 f1             	mov    rcx,rsi
    2b5f:	4c 8d 14 d6          	lea    r10,[rsi+rdx*8]
    2b63:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
    2b68:	48 8b 31             	mov    rsi,QWORD PTR [rcx]
    2b6b:	4c 89 ca             	mov    rdx,r9
    2b6e:	e8 7d ff ff ff       	call   2af0 <load_baseline>
    2b73:	0f b6 c0             	movzx  eax,al
    2b76:	2d 47 86 c8 61       	sub    eax,0x61c88647
    2b7b:	45 85 c0             	test   r8d,r8d
    2b7e:	74 1b                	je     2b9b <run_baseline+0x4b>
    2b80:	31 d2                	xor    edx,edx
    2b82:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    2b88:	69 c0 0d 66 19 00    	imul   eax,eax,0x19660d
    2b8e:	83 c2 01             	add    edx,0x1
    2b91:	05 5f f3 6e 3c       	add    eax,0x3c6ef35f
    2b96:	41 39 d0             	cmp    r8d,edx
    2b99:	75 ed                	jne    2b88 <run_baseline+0x38>
    2b9b:	0f b6 15 a7 24 00 00 	movzx  edx,BYTE PTR [rip+0x24a7]        # 5049 <e3_sink>
    2ba2:	48 83 c1 08          	add    rcx,0x8
    2ba6:	31 d0                	xor    eax,edx
    2ba8:	88 05 9b 24 00 00    	mov    BYTE PTR [rip+0x249b],al        # 5049 <e3_sink>
    2bae:	49 39 ca             	cmp    r10,rcx
    2bb1:	75 b5                	jne    2b68 <run_baseline+0x18>
    2bb3:	c3                   	ret
    2bb4:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
    2bbb:	00 00 00 00
    2bbf:	90                   	nop

0000000000002bc0 <run_lfence>:
    2bc0:	f3 0f 1e fa          	endbr64
    2bc4:	49 89 f2             	mov    r10,rsi
    2bc7:	49 89 d1             	mov    r9,rdx
    2bca:	49 89 cb             	mov    r11,rcx
    2bcd:	48 85 d2             	test   rdx,rdx
    2bd0:	74 51                	je     2c23 <run_lfence+0x63>
    2bd2:	31 c9                	xor    ecx,ecx
    2bd4:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
    2bd8:	49 8b 34 ca          	mov    rsi,QWORD PTR [r10+rcx*8]
    2bdc:	4c 89 da             	mov    rdx,r11
    2bdf:	e8 2c ff ff ff       	call   2b10 <load_lfence>
    2be4:	0f b6 c0             	movzx  eax,al
    2be7:	2d 47 86 c8 61       	sub    eax,0x61c88647
    2bec:	45 85 c0             	test   r8d,r8d
    2bef:	74 1a                	je     2c0b <run_lfence+0x4b>
    2bf1:	31 d2                	xor    edx,edx
    2bf3:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
    2bf8:	69 c0 0d 66 19 00    	imul   eax,eax,0x19660d
    2bfe:	83 c2 01             	add    edx,0x1
    2c01:	05 5f f3 6e 3c       	add    eax,0x3c6ef35f
    2c06:	41 39 d0             	cmp    r8d,edx
    2c09:	75 ed                	jne    2bf8 <run_lfence+0x38>
    2c0b:	0f b6 15 37 24 00 00 	movzx  edx,BYTE PTR [rip+0x2437]        # 5049 <e3_sink>
    2c12:	48 83 c1 01          	add    rcx,0x1
    2c16:	31 d0                	xor    eax,edx
    2c18:	88 05 2b 24 00 00    	mov    BYTE PTR [rip+0x242b],al        # 5049 <e3_sink>
    2c1e:	49 39 c9             	cmp    r9,rcx
    2c21:	75 b5                	jne    2bd8 <run_lfence+0x18>
    2c23:	c3                   	ret
    2c24:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
    2c2b:	00 00 00 00
    2c2f:	90                   	nop

0000000000002c30 <run_mask>:
    2c30:	f3 0f 1e fa          	endbr64
    2c34:	49 89 c9             	mov    r9,rcx
    2c37:	48 85 d2             	test   rdx,rdx
    2c3a:	74 57                	je     2c93 <run_mask+0x63>
    2c3c:	48 89 f1             	mov    rcx,rsi
    2c3f:	4c 8d 14 d6          	lea    r10,[rsi+rdx*8]
    2c43:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
    2c48:	48 8b 31             	mov    rsi,QWORD PTR [rcx]
    2c4b:	4c 89 ca             	mov    rdx,r9
    2c4e:	e8 dd fe ff ff       	call   2b30 <load_mask>
    2c53:	0f b6 c0             	movzx  eax,al
    2c56:	2d 47 86 c8 61       	sub    eax,0x61c88647
    2c5b:	45 85 c0             	test   r8d,r8d
    2c5e:	74 1b                	je     2c7b <run_mask+0x4b>
    2c60:	31 d2                	xor    edx,edx
    2c62:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    2c68:	69 c0 0d 66 19 00    	imul   eax,eax,0x19660d
    2c6e:	83 c2 01             	add    edx,0x1
    2c71:	05 5f f3 6e 3c       	add    eax,0x3c6ef35f
    2c76:	41 39 d0             	cmp    r8d,edx
    2c79:	75 ed                	jne    2c68 <run_mask+0x38>
    2c7b:	0f b6 15 c7 23 00 00 	movzx  edx,BYTE PTR [rip+0x23c7]        # 5049 <e3_sink>
    2c82:	48 83 c1 08          	add    rcx,0x8
    2c86:	31 d0                	xor    eax,edx
    2c88:	88 05 bb 23 00 00    	mov    BYTE PTR [rip+0x23bb],al        # 5049 <e3_sink>
    2c8e:	49 39 ca             	cmp    r10,rcx
    2c91:	75 b5                	jne    2c48 <run_mask+0x18>
    2c93:	c3                   	ret
    2c94:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
    2c9b:	00 00 00 00
    2c9f:	90                   	nop

0000000000002ca0 <csv_write_quoted>:
    2ca0:	55                   	push   rbp
    2ca1:	48 89 fd             	mov    rbp,rdi
    2ca4:	53                   	push   rbx
    2ca5:	48 89 f3             	mov    rbx,rsi
    2ca8:	48 89 fe             	mov    rsi,rdi
    2cab:	bf 22 00 00 00       	mov    edi,0x22
    2cb0:	48 83 ec 08          	sub    rsp,0x8
    2cb4:	e8 07 e6 ff ff       	call   12c0 <fputc@plt>
    2cb9:	0f b6 03             	movzx  eax,BYTE PTR [rbx]
    2cbc:	84 c0                	test   al,al
    2cbe:	75 19                	jne    2cd9 <csv_write_quoted+0x39>
    2cc0:	eb 42                	jmp    2d04 <csv_write_quoted+0x64>
    2cc2:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    2cc8:	e8 f3 e5 ff ff       	call   12c0 <fputc@plt>
    2ccd:	0f b6 43 01          	movzx  eax,BYTE PTR [rbx+0x1]
    2cd1:	48 83 c3 01          	add    rbx,0x1
    2cd5:	84 c0                	test   al,al
    2cd7:	74 2b                	je     2d04 <csv_write_quoted+0x64>
    2cd9:	3c 22                	cmp    al,0x22
    2cdb:	74 43                	je     2d20 <csv_write_quoted+0x80>
    2cdd:	0f be 3b             	movsx  edi,BYTE PTR [rbx]
    2ce0:	48 89 ee             	mov    rsi,rbp
    2ce3:	40 80 ff 0a          	cmp    dil,0xa
    2ce7:	74 06                	je     2cef <csv_write_quoted+0x4f>
    2ce9:	40 80 ff 0d          	cmp    dil,0xd
    2ced:	75 d9                	jne    2cc8 <csv_write_quoted+0x28>
    2cef:	bf 20 00 00 00       	mov    edi,0x20
    2cf4:	48 83 c3 01          	add    rbx,0x1
    2cf8:	e8 c3 e5 ff ff       	call   12c0 <fputc@plt>
    2cfd:	0f b6 03             	movzx  eax,BYTE PTR [rbx]
    2d00:	84 c0                	test   al,al
    2d02:	75 d5                	jne    2cd9 <csv_write_quoted+0x39>
    2d04:	48 83 c4 08          	add    rsp,0x8
    2d08:	48 89 ee             	mov    rsi,rbp
    2d0b:	bf 22 00 00 00       	mov    edi,0x22
    2d10:	5b                   	pop    rbx
    2d11:	5d                   	pop    rbp
    2d12:	e9 a9 e5 ff ff       	jmp    12c0 <fputc@plt>
    2d17:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
    2d1e:	00 00
    2d20:	48 89 ee             	mov    rsi,rbp
    2d23:	bf 22 00 00 00       	mov    edi,0x22
    2d28:	e8 93 e5 ff ff       	call   12c0 <fputc@plt>
    2d2d:	eb ae                	jmp    2cdd <csv_write_quoted+0x3d>
    2d2f:	90                   	nop

0000000000002d30 <parse_ull>:
    2d30:	41 54                	push   r12
    2d32:	55                   	push   rbp
    2d33:	53                   	push   rbx
    2d34:	48 83 ec 10          	sub    rsp,0x10
    2d38:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    2d3f:	00 00
    2d41:	48 89 44 24 08       	mov    QWORD PTR [rsp+0x8],rax
    2d46:	31 c0                	xor    eax,eax
    2d48:	48 85 ff             	test   rdi,rdi
    2d4b:	74 6b                	je     2db8 <parse_ull+0x88>
    2d4d:	80 3f 00             	cmp    BYTE PTR [rdi],0x0
    2d50:	48 89 fd             	mov    rbp,rdi
    2d53:	74 63                	je     2db8 <parse_ull+0x88>
    2d55:	49 89 f4             	mov    r12,rsi
    2d58:	e8 e3 e4 ff ff       	call   1240 <__errno_location@plt>
    2d5d:	48 89 e6             	mov    rsi,rsp
    2d60:	ba 0a 00 00 00       	mov    edx,0xa
    2d65:	48 89 ef             	mov    rdi,rbp
    2d68:	c7 00 00 00 00 00    	mov    DWORD PTR [rax],0x0
    2d6e:	48 89 c3             	mov    rbx,rax
    2d71:	48 c7 04 24 00 00 00 	mov    QWORD PTR [rsp],0x0
    2d78:	00
    2d79:	e8 72 e5 ff ff       	call   12f0 <strtoull@plt>
    2d7e:	44 8b 03             	mov    r8d,DWORD PTR [rbx]
    2d81:	45 85 c0             	test   r8d,r8d
    2d84:	75 32                	jne    2db8 <parse_ull+0x88>
    2d86:	48 8b 14 24          	mov    rdx,QWORD PTR [rsp]
    2d8a:	48 85 d2             	test   rdx,rdx
    2d8d:	74 29                	je     2db8 <parse_ull+0x88>
    2d8f:	80 3a 00             	cmp    BYTE PTR [rdx],0x0
    2d92:	75 24                	jne    2db8 <parse_ull+0x88>
    2d94:	49 89 04 24          	mov    QWORD PTR [r12],rax
    2d98:	48 8b 44 24 08       	mov    rax,QWORD PTR [rsp+0x8]
    2d9d:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
    2da4:	00 00
    2da6:	75 18                	jne    2dc0 <parse_ull+0x90>
    2da8:	48 83 c4 10          	add    rsp,0x10
    2dac:	44 89 c0             	mov    eax,r8d
    2daf:	5b                   	pop    rbx
    2db0:	5d                   	pop    rbp
    2db1:	41 5c                	pop    r12
    2db3:	c3                   	ret
    2db4:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
    2db8:	41 b8 ff ff ff ff    	mov    r8d,0xffffffff
    2dbe:	eb d8                	jmp    2d98 <parse_ull+0x68>
    2dc0:	e8 bb e4 ff ff       	call   1280 <__stack_chk_fail@plt>
    2dc5:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
    2dcc:	00 00 00 00

0000000000002dd0 <read_cpuinfo_field>:
    2dd0:	41 57                	push   r15
    2dd2:	41 56                	push   r14
    2dd4:	49 89 fe             	mov    r14,rdi
    2dd7:	48 8d 3d 28 02 00 00 	lea    rdi,[rip+0x228]        # 3006 <_IO_stdin_used+0x6>
    2dde:	41 55                	push   r13
    2de0:	49 89 d5             	mov    r13,rdx
    2de3:	41 54                	push   r12
    2de5:	55                   	push   rbp
    2de6:	53                   	push   rbx
    2de7:	48 81 ec 28 02 00 00 	sub    rsp,0x228
    2dee:	48 89 74 24 08       	mov    QWORD PTR [rsp+0x8],rsi
    2df3:	48 8d 35 0a 02 00 00 	lea    rsi,[rip+0x20a]        # 3004 <_IO_stdin_used+0x4>
    2dfa:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    2e01:	00 00
    2e03:	48 89 84 24 18 02 00 	mov    QWORD PTR [rsp+0x218],rax
    2e0a:	00
    2e0b:	31 c0                	xor    eax,eax
    2e0d:	e8 3e e5 ff ff       	call   1350 <fopen@plt>
    2e12:	48 85 c0             	test   rax,rax
    2e15:	0f 84 2f 01 00 00    	je     2f4a <read_cpuinfo_field+0x17a>
    2e1b:	4c 89 f7             	mov    rdi,r14
    2e1e:	48 89 c5             	mov    rbp,rax
    2e21:	4c 8d 64 24 10       	lea    r12,[rsp+0x10]
    2e26:	e8 45 e4 ff ff       	call   1270 <strlen@plt>
    2e2b:	48 89 c3             	mov    rbx,rax
    2e2e:	48 89 ea             	mov    rdx,rbp
    2e31:	be 00 02 00 00       	mov    esi,0x200
    2e36:	4c 89 e7             	mov    rdi,r12
    2e39:	e8 a2 e4 ff ff       	call   12e0 <fgets@plt>
    2e3e:	48 85 c0             	test   rax,rax
    2e41:	0f 84 f5 00 00 00    	je     2f3c <read_cpuinfo_field+0x16c>
    2e47:	48 89 da             	mov    rdx,rbx
    2e4a:	4c 89 f6             	mov    rsi,r14
    2e4d:	4c 89 e7             	mov    rdi,r12
    2e50:	e8 fb e3 ff ff       	call   1250 <strncmp@plt>
    2e55:	41 89 c7             	mov    r15d,eax
    2e58:	85 c0                	test   eax,eax
    2e5a:	75 d2                	jne    2e2e <read_cpuinfo_field+0x5e>
    2e5c:	49 8d 04 1c          	lea    rax,[r12+rbx*1]
    2e60:	0f b6 10             	movzx  edx,BYTE PTR [rax]
    2e63:	80 fa 20             	cmp    dl,0x20
    2e66:	75 15                	jne    2e7d <read_cpuinfo_field+0xad>
    2e68:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
    2e6f:	00
    2e70:	0f b6 50 01          	movzx  edx,BYTE PTR [rax+0x1]
    2e74:	48 83 c0 01          	add    rax,0x1
    2e78:	80 fa 20             	cmp    dl,0x20
    2e7b:	74 f3                	je     2e70 <read_cpuinfo_field+0xa0>
    2e7d:	80 fa 09             	cmp    dl,0x9
    2e80:	74 ee                	je     2e70 <read_cpuinfo_field+0xa0>
    2e82:	80 fa 3a             	cmp    dl,0x3a
    2e85:	75 a7                	jne    2e2e <read_cpuinfo_field+0x5e>
    2e87:	4c 8d 70 01          	lea    r14,[rax+0x1]
    2e8b:	0f b6 40 01          	movzx  eax,BYTE PTR [rax+0x1]
    2e8f:	3c 09                	cmp    al,0x9
    2e91:	74 0d                	je     2ea0 <read_cpuinfo_field+0xd0>
    2e93:	3c 20                	cmp    al,0x20
    2e95:	75 1a                	jne    2eb1 <read_cpuinfo_field+0xe1>
    2e97:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
    2e9e:	00 00
    2ea0:	41 0f b6 46 01       	movzx  eax,BYTE PTR [r14+0x1]
    2ea5:	49 83 c6 01          	add    r14,0x1
    2ea9:	3c 20                	cmp    al,0x20
    2eab:	74 f3                	je     2ea0 <read_cpuinfo_field+0xd0>
    2ead:	3c 09                	cmp    al,0x9
    2eaf:	74 ef                	je     2ea0 <read_cpuinfo_field+0xd0>
    2eb1:	4c 89 f7             	mov    rdi,r14
    2eb4:	e8 b7 e3 ff ff       	call   1270 <strlen@plt>
    2eb9:	4c 01 f0             	add    rax,r14
    2ebc:	4c 39 f0             	cmp    rax,r14
    2ebf:	76 18                	jbe    2ed9 <read_cpuinfo_field+0x109>
    2ec1:	48 b9 ff d9 ff ff fe 	movabs rcx,0xfffffffeffffd9ff
    2ec8:	ff ff ff
    2ecb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
    2ed0:	0f b6 50 ff          	movzx  edx,BYTE PTR [rax-0x1]
    2ed4:	80 fa 20             	cmp    dl,0x20
    2ed7:	76 4f                	jbe    2f28 <read_cpuinfo_field+0x158>
    2ed9:	48 8b 7c 24 08       	mov    rdi,QWORD PTR [rsp+0x8]
    2ede:	4c 89 f1             	mov    rcx,r14
    2ee1:	4c 89 ee             	mov    rsi,r13
    2ee4:	31 c0                	xor    eax,eax
    2ee6:	48 8d 15 27 01 00 00 	lea    rdx,[rip+0x127]        # 3014 <_IO_stdin_used+0x14>
    2eed:	e8 9e e3 ff ff       	call   1290 <snprintf@plt>
    2ef2:	48 89 ef             	mov    rdi,rbp
    2ef5:	e8 66 e3 ff ff       	call   1260 <fclose@plt>
    2efa:	48 8b 84 24 18 02 00 	mov    rax,QWORD PTR [rsp+0x218]
    2f01:	00
    2f02:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
    2f09:	00 00
    2f0b:	75 43                	jne    2f50 <read_cpuinfo_field+0x180>
    2f0d:	48 81 c4 28 02 00 00 	add    rsp,0x228
    2f14:	44 89 f8             	mov    eax,r15d
    2f17:	5b                   	pop    rbx
    2f18:	5d                   	pop    rbp
    2f19:	41 5c                	pop    r12
    2f1b:	41 5d                	pop    r13
    2f1d:	41 5e                	pop    r14
    2f1f:	41 5f                	pop    r15
    2f21:	c3                   	ret
    2f22:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    2f28:	48 0f a3 d1          	bt     rcx,rdx
    2f2c:	72 ab                	jb     2ed9 <read_cpuinfo_field+0x109>
    2f2e:	48 83 e8 01          	sub    rax,0x1
    2f32:	c6 00 00             	mov    BYTE PTR [rax],0x0
    2f35:	4c 39 f0             	cmp    rax,r14
    2f38:	75 96                	jne    2ed0 <read_cpuinfo_field+0x100>
    2f3a:	eb 9d                	jmp    2ed9 <read_cpuinfo_field+0x109>
    2f3c:	48 89 ef             	mov    rdi,rbp
    2f3f:	41 83 cf ff          	or     r15d,0xffffffff
    2f43:	e8 18 e3 ff ff       	call   1260 <fclose@plt>
    2f48:	eb b0                	jmp    2efa <read_cpuinfo_field+0x12a>
    2f4a:	41 83 cf ff          	or     r15d,0xffffffff
    2f4e:	eb aa                	jmp    2efa <read_cpuinfo_field+0x12a>
    2f50:	e8 2b e3 ff ff       	call   1280 <__stack_chk_fail@plt>
    2f55:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
    2f5c:	00 00 00 00

0000000000002f60 <usage>:
    2f60:	48 83 ec 08          	sub    rsp,0x8
    2f64:	48 89 f9             	mov    rcx,rdi
    2f67:	48 8d 05 bc 00 00 00 	lea    rax,[rip+0xbc]        # 302a <_IO_stdin_used+0x2a>
    2f6e:	48 8b 3d cb 20 00 00 	mov    rdi,QWORD PTR [rip+0x20cb]        # 5040 <stderr@GLIBC_2.2.5>
    2f75:	68 00 01 00 00       	push   0x100
    2f7a:	4c 8d 0d ef 01 00 00 	lea    r9,[rip+0x1ef]        # 3170 <_IO_stdin_used+0x170>
    2f81:	4c 8d 05 8f 00 00 00 	lea    r8,[rip+0x8f]        # 3017 <_IO_stdin_used+0x17>
    2f88:	be 01 00 00 00       	mov    esi,0x1
    2f8d:	68 04 29 35 01       	push   0x1352904
    2f92:	48 8d 15 ff 01 00 00 	lea    rdx,[rip+0x1ff]        # 3198 <_IO_stdin_used+0x198>
    2f99:	6a 03                	push   0x3
    2f9b:	6a 05                	push   0x5
    2f9d:	68 40 0d 03 00       	push   0x30d40
    2fa2:	50                   	push   rax
    2fa3:	31 c0                	xor    eax,eax
    2fa5:	e8 d6 e3 ff ff       	call   1380 <__fprintf_chk@plt>
    2faa:	48 83 c4 38          	add    rsp,0x38
    2fae:	c3                   	ret

Disassembly of section .fini:

0000000000002fb0 <_fini>:
    2fb0:	f3 0f 1e fa          	endbr64
    2fb4:	48 83 ec 08          	sub    rsp,0x8
    2fb8:	48 83 c4 08          	add    rsp,0x8
    2fbc:	c3                   	ret
