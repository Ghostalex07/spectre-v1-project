
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
    13db:	48 81 ec d8 05 00 00 	sub    rsp,0x5d8
    13e2:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    13e9:	00 00 
    13eb:	48 89 84 24 c8 05 00 	mov    QWORD PTR [rsp+0x5c8],rax
    13f2:	00 
    13f3:	31 c0                	xor    eax,eax
    13f5:	e8 06 fe ff ff       	call   1200 <getenv@plt>
    13fa:	48 c7 84 24 20 01 00 	mov    QWORD PTR [rsp+0x120],0x30d40
    1401:	00 40 0d 03 00 
    1406:	48 89 44 24 28       	mov    QWORD PTR [rsp+0x28],rax
    140b:	48 c7 84 24 28 01 00 	mov    QWORD PTR [rsp+0x128],0x5
    1412:	00 05 00 00 00 
    1417:	48 c7 84 24 30 01 00 	mov    QWORD PTR [rsp+0x130],0x3
    141e:	00 03 00 00 00 
    1423:	48 c7 84 24 38 01 00 	mov    QWORD PTR [rsp+0x138],0x1352904
    142a:	00 04 29 35 01 
    142f:	48 c7 84 24 40 01 00 	mov    QWORD PTR [rsp+0x140],0x100
    1436:	00 00 01 00 00 
    143b:	41 83 fd 01          	cmp    r13d,0x1
    143f:	0f 8e c5 09 00 00    	jle    1e0a <main+0xa4a>
    1445:	48 8d 45 08          	lea    rax,[rbp+0x8]
    1449:	bb 02 00 00 00       	mov    ebx,0x2
    144e:	45 31 e4             	xor    r12d,r12d
    1451:	48 c7 44 24 08 00 00 	mov    QWORD PTR [rsp+0x8],0x0
    1458:	00 00 
    145a:	48 89 44 24 18       	mov    QWORD PTR [rsp+0x18],rax
    145f:	41 8d 45 fe          	lea    eax,[r13-0x2]
    1463:	4c 8d 3d ad 1b 00 00 	lea    r15,[rip+0x1bad]        # 3017 <_IO_stdin_used+0x17>
    146a:	83 e0 fe             	and    eax,0xfffffffe
    146d:	83 c0 04             	add    eax,0x4
    1470:	89 44 24 20          	mov    DWORD PTR [rsp+0x20],eax
    1474:	48 8d 05 af 1b 00 00 	lea    rax,[rip+0x1baf]        # 302a <_IO_stdin_used+0x2a>
    147b:	48 89 44 24 10       	mov    QWORD PTR [rsp+0x10],rax
    1480:	48 8d 05 e1 1c 00 00 	lea    rax,[rip+0x1ce1]        # 3168 <_IO_stdin_used+0x168>
    1487:	48 89 04 24          	mov    QWORD PTR [rsp],rax
    148b:	eb 1c                	jmp    14a9 <main+0xe9>
    148d:	44 39 eb             	cmp    ebx,r13d
    1490:	7d 49                	jge    14db <main+0x11b>
    1492:	48 63 c3             	movsxd rax,ebx
    1495:	4c 8b 64 c5 00       	mov    r12,QWORD PTR [rbp+rax*8+0x0]
    149a:	48 83 44 24 18 10    	add    QWORD PTR [rsp+0x18],0x10
    14a0:	83 c3 02             	add    ebx,0x2
    14a3:	39 5c 24 20          	cmp    DWORD PTR [rsp+0x20],ebx
    14a7:	74 6e                	je     1517 <main+0x157>
    14a9:	48 8b 44 24 18       	mov    rax,QWORD PTR [rsp+0x18]
    14ae:	48 8d 35 9d 1b 00 00 	lea    rsi,[rip+0x1b9d]        # 3052 <_IO_stdin_used+0x52>
    14b5:	4c 8b 30             	mov    r14,QWORD PTR [rax]
    14b8:	4c 89 f7             	mov    rdi,r14
    14bb:	e8 40 fe ff ff       	call   1300 <strcmp@plt>
    14c0:	85 c0                	test   eax,eax
    14c2:	0f 84 4a 04 00 00    	je     1912 <main+0x552>
    14c8:	48 8d 35 8a 1b 00 00 	lea    rsi,[rip+0x1b8a]        # 3059 <_IO_stdin_used+0x59>
    14cf:	4c 89 f7             	mov    rdi,r14
    14d2:	e8 29 fe ff ff       	call   1300 <strcmp@plt>
    14d7:	85 c0                	test   eax,eax
    14d9:	74 b2                	je     148d <main+0xcd>
    14db:	48 8d 35 84 1b 00 00 	lea    rsi,[rip+0x1b84]        # 3066 <_IO_stdin_used+0x66>
    14e2:	4c 89 f7             	mov    rdi,r14
    14e5:	e8 16 fe ff ff       	call   1300 <strcmp@plt>
    14ea:	85 c0                	test   eax,eax
    14ec:	0f 85 ee 01 00 00    	jne    16e0 <main+0x320>
    14f2:	44 39 eb             	cmp    ebx,r13d
    14f5:	0f 8d e5 01 00 00    	jge    16e0 <main+0x320>
    14fb:	48 63 c3             	movsxd rax,ebx
    14fe:	48 83 44 24 18 10    	add    QWORD PTR [rsp+0x18],0x10
    1504:	83 c3 02             	add    ebx,0x2
    1507:	48 8b 44 c5 00       	mov    rax,QWORD PTR [rbp+rax*8+0x0]
    150c:	48 89 44 24 28       	mov    QWORD PTR [rsp+0x28],rax
    1511:	39 5c 24 20          	cmp    DWORD PTR [rsp+0x20],ebx
    1515:	75 92                	jne    14a9 <main+0xe9>
    1517:	4c 8b ac 24 20 01 00 	mov    r13,QWORD PTR [rsp+0x120]
    151e:	00 
    151f:	48 b8 fe ff ff ff ff 	movabs rax,0x1ffffffffffffffe
    1526:	ff ff 1f 
    1529:	49 8d 55 ff          	lea    rdx,[r13-0x1]
    152d:	48 39 c2             	cmp    rdx,rax
    1530:	0f 87 c8 08 00 00    	ja     1dfe <main+0xa3e>
    1536:	48 8b 84 24 28 01 00 	mov    rax,QWORD PTR [rsp+0x128]
    153d:	00 
    153e:	48 89 84 24 a0 00 00 	mov    QWORD PTR [rsp+0xa0],rax
    1545:	00 
    1546:	48 83 e8 01          	sub    rax,0x1
    154a:	48 3d fe ff ff 7f    	cmp    rax,0x7ffffffe
    1550:	0f 87 9c 08 00 00    	ja     1df2 <main+0xa32>
    1556:	48 8b 84 24 30 01 00 	mov    rax,QWORD PTR [rsp+0x130]
    155d:	00 
    155e:	48 89 44 24 78       	mov    QWORD PTR [rsp+0x78],rax
    1563:	48 83 e8 01          	sub    rax,0x1
    1567:	48 3d fe ff ff 7f    	cmp    rax,0x7ffffffe
    156d:	0f 87 7f 08 00 00    	ja     1df2 <main+0xa32>
    1573:	48 83 bc 24 40 01 00 	cmp    QWORD PTR [rsp+0x140],0x0
    157a:	00 00 
    157c:	0f 84 51 08 00 00    	je     1dd3 <main+0xa13>
    1582:	4c 89 ff             	mov    rdi,r15
    1585:	e8 16 fe ff ff       	call   13a0 <strdup@plt>
    158a:	49 89 c7             	mov    r15,rax
    158d:	48 85 c0             	test   rax,rax
    1590:	0f 84 19 01 00 00    	je     16af <main+0x2ef>
    1596:	48 8d ac 24 48 01 00 	lea    rbp,[rsp+0x148]
    159d:	00 
    159e:	48 89 c7             	mov    rdi,rax
    15a1:	4c 8d 35 24 1b 00 00 	lea    r14,[rip+0x1b24]        # 30cc <_IO_stdin_used+0xcc>
    15a8:	48 c7 84 24 48 01 00 	mov    QWORD PTR [rsp+0x148],0x0
    15af:	00 00 00 00 00 
    15b4:	48 89 ea             	mov    rdx,rbp
    15b7:	4c 89 f6             	mov    rsi,r14
    15ba:	e8 11 fd ff ff       	call   12d0 <strtok_r@plt>
    15bf:	48 89 c7             	mov    rdi,rax
    15c2:	48 85 c0             	test   rax,rax
    15c5:	0f 84 dc 00 00 00    	je     16a7 <main+0x2e7>
    15cb:	31 db                	xor    ebx,ebx
    15cd:	31 c9                	xor    ecx,ecx
    15cf:	4c 89 64 24 18       	mov    QWORD PTR [rsp+0x18],r12
    15d4:	48 8d 84 24 50 01 00 	lea    rax,[rsp+0x150]
    15db:	00 
    15dc:	49 89 dc             	mov    r12,rbx
    15df:	48 89 84 24 c0 00 00 	mov    QWORD PTR [rsp+0xc0],rax
    15e6:	00 
    15e7:	48 89 eb             	mov    rbx,rbp
    15ea:	48 89 cd             	mov    rbp,rcx
    15ed:	48 c7 84 24 d0 00 00 	mov    QWORD PTR [rsp+0xd0],0x0
    15f4:	00 00 00 00 00 
    15f9:	eb 42                	jmp    163d <main+0x27d>
    15fb:	48 8b 84 24 d0 00 00 	mov    rax,QWORD PTR [rsp+0xd0]
    1602:	00 
    1603:	31 ff                	xor    edi,edi
    1605:	4c 89 f6             	mov    rsi,r14
    1608:	48 83 c0 01          	add    rax,0x1
    160c:	48 89 54 c5 f8       	mov    QWORD PTR [rbp+rax*8-0x8],rdx
    1611:	48 89 da             	mov    rdx,rbx
    1614:	48 89 84 24 e0 00 00 	mov    QWORD PTR [rsp+0xe0],rax
    161b:	00 
    161c:	e8 af fc ff ff       	call   12d0 <strtok_r@plt>
    1621:	48 89 c7             	mov    rdi,rax
    1624:	48 85 c0             	test   rax,rax
    1627:	0f 84 30 03 00 00    	je     195d <main+0x59d>
    162d:	48 8b 84 24 e0 00 00 	mov    rax,QWORD PTR [rsp+0xe0]
    1634:	00 
    1635:	48 89 84 24 d0 00 00 	mov    QWORD PTR [rsp+0xd0],rax
    163c:	00 
    163d:	48 8b b4 24 c0 00 00 	mov    rsi,QWORD PTR [rsp+0xc0]
    1644:	00 
    1645:	48 c7 84 24 50 01 00 	mov    QWORD PTR [rsp+0x150],0x0
    164c:	00 00 00 00 00 
    1651:	e8 8a 16 00 00       	call   2ce0 <parse_ull>
    1656:	85 c0                	test   eax,eax
    1658:	75 4d                	jne    16a7 <main+0x2e7>
    165a:	48 8b 94 24 50 01 00 	mov    rdx,QWORD PTR [rsp+0x150]
    1661:	00 
    1662:	48 81 fa 40 42 0f 00 	cmp    rdx,0xf4240
    1669:	77 3c                	ja     16a7 <main+0x2e7>
    166b:	4c 3b a4 24 d0 00 00 	cmp    r12,QWORD PTR [rsp+0xd0]
    1672:	00 
    1673:	75 86                	jne    15fb <main+0x23b>
    1675:	4d 85 e4             	test   r12,r12
    1678:	0f 84 d4 02 00 00    	je     1952 <main+0x592>
    167e:	4d 01 e4             	add    r12,r12
    1681:	48 89 ef             	mov    rdi,rbp
    1684:	4a 8d 34 e5 00 00 00 	lea    rsi,[r12*8+0x0]
    168b:	00 
    168c:	48 89 54 24 20       	mov    QWORD PTR [rsp+0x20],rdx
    1691:	e8 9a fc ff ff       	call   1330 <realloc@plt>
    1696:	48 8b 54 24 20       	mov    rdx,QWORD PTR [rsp+0x20]
    169b:	48 85 c0             	test   rax,rax
    169e:	48 89 c5             	mov    rbp,rax
    16a1:	0f 85 54 ff ff ff    	jne    15fb <main+0x23b>
    16a7:	4c 89 ff             	mov    rdi,r15
    16aa:	e8 71 fb ff ff       	call   1220 <free@plt>
    16af:	48 8d 15 7a 1f 00 00 	lea    rdx,[rip+0x1f7a]        # 3630 <_IO_stdin_used+0x630>
    16b6:	48 8b 3d 83 39 00 00 	mov    rdi,QWORD PTR [rip+0x3983]        # 5040 <stderr@GLIBC_2.2.5>
    16bd:	be 01 00 00 00       	mov    esi,0x1
    16c2:	31 c0                	xor    eax,eax
    16c4:	e8 b7 fc ff ff       	call   1380 <__fprintf_chk@plt>
    16c9:	c7 84 24 9c 00 00 00 	mov    DWORD PTR [rsp+0x9c],0x2
    16d0:	02 00 00 00 
    16d4:	e9 49 02 00 00       	jmp    1922 <main+0x562>
    16d9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    16e0:	48 8d 35 8c 19 00 00 	lea    rsi,[rip+0x198c]        # 3073 <_IO_stdin_used+0x73>
    16e7:	4c 89 f7             	mov    rdi,r14
    16ea:	e8 11 fc ff ff       	call   1300 <strcmp@plt>
    16ef:	85 c0                	test   eax,eax
    16f1:	75 12                	jne    1705 <main+0x345>
    16f3:	44 39 eb             	cmp    ebx,r13d
    16f6:	7d 0d                	jge    1705 <main+0x345>
    16f8:	48 63 c3             	movsxd rax,ebx
    16fb:	4c 8b 7c c5 00       	mov    r15,QWORD PTR [rbp+rax*8+0x0]
    1700:	e9 95 fd ff ff       	jmp    149a <main+0xda>
    1705:	48 8d 35 6e 19 00 00 	lea    rsi,[rip+0x196e]        # 307a <_IO_stdin_used+0x7a>
    170c:	4c 89 f7             	mov    rdi,r14
    170f:	e8 ec fb ff ff       	call   1300 <strcmp@plt>
    1714:	85 c0                	test   eax,eax
    1716:	75 16                	jne    172e <main+0x36e>
    1718:	44 39 eb             	cmp    ebx,r13d
    171b:	7d 11                	jge    172e <main+0x36e>
    171d:	48 63 c3             	movsxd rax,ebx
    1720:	48 8b 44 c5 00       	mov    rax,QWORD PTR [rbp+rax*8+0x0]
    1725:	48 89 04 24          	mov    QWORD PTR [rsp],rax
    1729:	e9 6c fd ff ff       	jmp    149a <main+0xda>
    172e:	48 8d 35 56 19 00 00 	lea    rsi,[rip+0x1956]        # 308b <_IO_stdin_used+0x8b>
    1735:	4c 89 f7             	mov    rdi,r14
    1738:	e8 c3 fb ff ff       	call   1300 <strcmp@plt>
    173d:	85 c0                	test   eax,eax
    173f:	75 17                	jne    1758 <main+0x398>
    1741:	44 39 eb             	cmp    ebx,r13d
    1744:	7d 12                	jge    1758 <main+0x398>
    1746:	48 63 c3             	movsxd rax,ebx
    1749:	48 8b 44 c5 00       	mov    rax,QWORD PTR [rbp+rax*8+0x0]
    174e:	48 89 44 24 10       	mov    QWORD PTR [rsp+0x10],rax
    1753:	e9 42 fd ff ff       	jmp    149a <main+0xda>
    1758:	48 8d 35 3a 19 00 00 	lea    rsi,[rip+0x193a]        # 3099 <_IO_stdin_used+0x99>
    175f:	4c 89 f7             	mov    rdi,r14
    1762:	e8 99 fb ff ff       	call   1300 <strcmp@plt>
    1767:	85 c0                	test   eax,eax
    1769:	75 09                	jne    1774 <main+0x3b4>
    176b:	44 39 eb             	cmp    ebx,r13d
    176e:	0f 8c 89 00 00 00    	jl     17fd <main+0x43d>
    1774:	48 8d 35 2b 19 00 00 	lea    rsi,[rip+0x192b]        # 30a6 <_IO_stdin_used+0xa6>
    177b:	4c 89 f7             	mov    rdi,r14
    177e:	e8 7d fb ff ff       	call   1300 <strcmp@plt>
    1783:	85 c0                	test   eax,eax
    1785:	0f 85 15 01 00 00    	jne    18a0 <main+0x4e0>
    178b:	44 39 eb             	cmp    ebx,r13d
    178e:	0f 8c e1 00 00 00    	jl     1875 <main+0x4b5>
    1794:	48 8d 35 1b 19 00 00 	lea    rsi,[rip+0x191b]        # 30b6 <_IO_stdin_used+0xb6>
    179b:	4c 89 f7             	mov    rdi,r14
    179e:	e8 5d fb ff ff       	call   1300 <strcmp@plt>
    17a3:	85 c0                	test   eax,eax
    17a5:	0f 85 85 00 00 00    	jne    1830 <main+0x470>
    17ab:	44 39 eb             	cmp    ebx,r13d
    17ae:	0f 8c 35 01 00 00    	jl     18e9 <main+0x529>
    17b4:	48 8d 35 02 19 00 00 	lea    rsi,[rip+0x1902]        # 30bd <_IO_stdin_used+0xbd>
    17bb:	4c 89 f7             	mov    rdi,r14
    17be:	e8 3d fb ff ff       	call   1300 <strcmp@plt>
    17c3:	85 c0                	test   eax,eax
    17c5:	0f 84 80 06 00 00    	je     1e4b <main+0xa8b>
    17cb:	48 8d 35 f4 18 00 00 	lea    rsi,[rip+0x18f4]        # 30c6 <_IO_stdin_used+0xc6>
    17d2:	4c 89 f7             	mov    rdi,r14
    17d5:	e8 26 fb ff ff       	call   1300 <strcmp@plt>
    17da:	85 c0                	test   eax,eax
    17dc:	0f 85 69 06 00 00    	jne    1e4b <main+0xa8b>
    17e2:	44 39 eb             	cmp    ebx,r13d
    17e5:	0f 8d 60 06 00 00    	jge    1e4b <main+0xa8b>
    17eb:	48 63 c3             	movsxd rax,ebx
    17ee:	48 8b 44 c5 00       	mov    rax,QWORD PTR [rbp+rax*8+0x0]
    17f3:	48 89 44 24 08       	mov    QWORD PTR [rsp+0x8],rax
    17f8:	e9 9d fc ff ff       	jmp    149a <main+0xda>
    17fd:	48 63 c3             	movsxd rax,ebx
    1800:	48 8d b4 24 20 01 00 	lea    rsi,[rsp+0x120]
    1807:	00 
    1808:	48 8b 7c c5 00       	mov    rdi,QWORD PTR [rbp+rax*8+0x0]
    180d:	e8 ce 14 00 00       	call   2ce0 <parse_ull>
    1812:	85 c0                	test   eax,eax
    1814:	0f 84 80 fc ff ff    	je     149a <main+0xda>
    181a:	48 8d 15 97 1c 00 00 	lea    rdx,[rip+0x1c97]        # 34b8 <_IO_stdin_used+0x4b8>
    1821:	e9 90 fe ff ff       	jmp    16b6 <main+0x2f6>
    1826:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    182d:	00 00 00 
    1830:	48 8d 35 86 18 00 00 	lea    rsi,[rip+0x1886]        # 30bd <_IO_stdin_used+0xbd>
    1837:	4c 89 f7             	mov    rdi,r14
    183a:	e8 c1 fa ff ff       	call   1300 <strcmp@plt>
    183f:	85 c0                	test   eax,eax
    1841:	75 88                	jne    17cb <main+0x40b>
    1843:	44 39 eb             	cmp    ebx,r13d
    1846:	0f 8d ff 05 00 00    	jge    1e4b <main+0xa8b>
    184c:	48 63 c3             	movsxd rax,ebx
    184f:	48 8d b4 24 40 01 00 	lea    rsi,[rsp+0x140]
    1856:	00 
    1857:	48 8b 7c c5 00       	mov    rdi,QWORD PTR [rbp+rax*8+0x0]
    185c:	e8 7f 14 00 00       	call   2ce0 <parse_ull>
    1861:	85 c0                	test   eax,eax
    1863:	0f 84 31 fc ff ff    	je     149a <main+0xda>
    1869:	48 8d 15 f8 1c 00 00 	lea    rdx,[rip+0x1cf8]        # 3568 <_IO_stdin_used+0x568>
    1870:	e9 41 fe ff ff       	jmp    16b6 <main+0x2f6>
    1875:	48 63 c3             	movsxd rax,ebx
    1878:	48 8d b4 24 28 01 00 	lea    rsi,[rsp+0x128]
    187f:	00 
    1880:	48 8b 7c c5 00       	mov    rdi,QWORD PTR [rbp+rax*8+0x0]
    1885:	e8 56 14 00 00       	call   2ce0 <parse_ull>
    188a:	85 c0                	test   eax,eax
    188c:	0f 84 08 fc ff ff    	je     149a <main+0xda>
    1892:	48 8d 15 4f 1c 00 00 	lea    rdx,[rip+0x1c4f]        # 34e8 <_IO_stdin_used+0x4e8>
    1899:	e9 18 fe ff ff       	jmp    16b6 <main+0x2f6>
    189e:	66 90                	xchg   ax,ax
    18a0:	48 8d 35 08 18 00 00 	lea    rsi,[rip+0x1808]        # 30af <_IO_stdin_used+0xaf>
    18a7:	4c 89 f7             	mov    rdi,r14
    18aa:	e8 51 fa ff ff       	call   1300 <strcmp@plt>
    18af:	85 c0                	test   eax,eax
    18b1:	0f 85 dd fe ff ff    	jne    1794 <main+0x3d4>
    18b7:	44 39 eb             	cmp    ebx,r13d
    18ba:	0f 8d d4 fe ff ff    	jge    1794 <main+0x3d4>
    18c0:	48 63 c3             	movsxd rax,ebx
    18c3:	48 8d b4 24 30 01 00 	lea    rsi,[rsp+0x130]
    18ca:	00 
    18cb:	48 8b 7c c5 00       	mov    rdi,QWORD PTR [rbp+rax*8+0x0]
    18d0:	e8 0b 14 00 00       	call   2ce0 <parse_ull>
    18d5:	85 c0                	test   eax,eax
    18d7:	0f 84 bd fb ff ff    	je     149a <main+0xda>
    18dd:	48 8d 15 34 1c 00 00 	lea    rdx,[rip+0x1c34]        # 3518 <_IO_stdin_used+0x518>
    18e4:	e9 cd fd ff ff       	jmp    16b6 <main+0x2f6>
    18e9:	48 63 c3             	movsxd rax,ebx
    18ec:	48 8d b4 24 38 01 00 	lea    rsi,[rsp+0x138]
    18f3:	00 
    18f4:	48 8b 7c c5 00       	mov    rdi,QWORD PTR [rbp+rax*8+0x0]
    18f9:	e8 e2 13 00 00       	call   2ce0 <parse_ull>
    18fe:	85 c0                	test   eax,eax
    1900:	0f 84 94 fb ff ff    	je     149a <main+0xda>
    1906:	48 8d 15 33 1c 00 00 	lea    rdx,[rip+0x1c33]        # 3540 <_IO_stdin_used+0x540>
    190d:	e9 a4 fd ff ff       	jmp    16b6 <main+0x2f6>
    1912:	48 8b 7d 00          	mov    rdi,QWORD PTR [rbp+0x0]
    1916:	89 84 24 9c 00 00 00 	mov    DWORD PTR [rsp+0x9c],eax
    191d:	e8 ee 15 00 00       	call   2f10 <usage>
    1922:	48 8b 84 24 c8 05 00 	mov    rax,QWORD PTR [rsp+0x5c8]
    1929:	00 
    192a:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
    1931:	00 00 
    1933:	0f 85 48 05 00 00    	jne    1e81 <main+0xac1>
    1939:	8b 84 24 9c 00 00 00 	mov    eax,DWORD PTR [rsp+0x9c]
    1940:	48 81 c4 d8 05 00 00 	add    rsp,0x5d8
    1947:	5b                   	pop    rbx
    1948:	5d                   	pop    rbp
    1949:	41 5c                	pop    r12
    194b:	41 5d                	pop    r13
    194d:	41 5e                	pop    r14
    194f:	41 5f                	pop    r15
    1951:	c3                   	ret    
    1952:	41 bc 10 00 00 00    	mov    r12d,0x10
    1958:	e9 24 fd ff ff       	jmp    1681 <main+0x2c1>
    195d:	4c 89 ff             	mov    rdi,r15
    1960:	48 89 ac 24 c8 00 00 	mov    QWORD PTR [rsp+0xc8],rbp
    1967:	00 
    1968:	4c 8b 64 24 18       	mov    r12,QWORD PTR [rsp+0x18]
    196d:	48 89 dd             	mov    rbp,rbx
    1970:	48 89 84 24 b0 00 00 	mov    QWORD PTR [rsp+0xb0],rax
    1977:	00 
    1978:	e8 a3 f8 ff ff       	call   1220 <free@plt>
    197d:	48 83 bc 24 e0 00 00 	cmp    QWORD PTR [rsp+0xe0],0x0
    1984:	00 00 
    1986:	0f 84 23 fd ff ff    	je     16af <main+0x2ef>
    198c:	48 8b 3c 24          	mov    rdi,QWORD PTR [rsp]
    1990:	e8 0b fa ff ff       	call   13a0 <strdup@plt>
    1995:	49 89 c7             	mov    r15,rax
    1998:	48 85 c0             	test   rax,rax
    199b:	0f 84 f1 03 00 00    	je     1d92 <main+0x9d2>
    19a1:	48 89 ea             	mov    rdx,rbp
    19a4:	4c 89 f6             	mov    rsi,r14
    19a7:	48 89 c7             	mov    rdi,rax
    19aa:	48 c7 84 24 48 01 00 	mov    QWORD PTR [rsp+0x148],0x0
    19b1:	00 00 00 00 00 
    19b6:	e8 15 f9 ff ff       	call   12d0 <strtok_r@plt>
    19bb:	48 85 c0             	test   rax,rax
    19be:	0f 84 93 0f 00 00    	je     2957 <main+0x1597>
    19c4:	31 f6                	xor    esi,esi
    19c6:	48 8d 8c 24 20 03 00 	lea    rcx,[rsp+0x320]
    19cd:	00 
    19ce:	4c 89 6c 24 20       	mov    QWORD PTR [rsp+0x20],r13
    19d3:	31 db                	xor    ebx,ebx
    19d5:	4c 89 64 24 38       	mov    QWORD PTR [rsp+0x38],r12
    19da:	4c 8b ac 24 b0 00 00 	mov    r13,QWORD PTR [rsp+0xb0]
    19e1:	00 
    19e2:	49 89 f4             	mov    r12,rsi
    19e5:	4c 89 7c 24 18       	mov    QWORD PTR [rsp+0x18],r15
    19ea:	49 89 c7             	mov    r15,rax
    19ed:	48 c7 04 24 00 00 00 	mov    QWORD PTR [rsp],0x0
    19f4:	00 
    19f5:	48 89 4c 24 30       	mov    QWORD PTR [rsp+0x30],rcx
    19fa:	e9 d5 00 00 00       	jmp    1ad4 <main+0x714>
    19ff:	ba 08 00 00 00       	mov    edx,0x8
    1a04:	48 8d 35 cb 16 00 00 	lea    rsi,[rip+0x16cb]        # 30d6 <_IO_stdin_used+0xd6>
    1a0b:	4c 89 ff             	mov    rdi,r15
    1a0e:	e8 3d f8 ff ff       	call   1250 <strncmp@plt>
    1a13:	85 c0                	test   eax,eax
    1a15:	0f 85 6d 03 00 00    	jne    1d88 <main+0x9c8>
    1a1b:	48 8b b4 24 c0 00 00 	mov    rsi,QWORD PTR [rsp+0xc0]
    1a22:	00 
    1a23:	49 8d 7f 08          	lea    rdi,[r15+0x8]
    1a27:	48 c7 84 24 50 01 00 	mov    QWORD PTR [rsp+0x150],0x0
    1a2e:	00 00 00 00 00 
    1a33:	e8 a8 12 00 00       	call   2ce0 <parse_ull>
    1a38:	85 c0                	test   eax,eax
    1a3a:	0f 85 48 03 00 00    	jne    1d88 <main+0x9c8>
    1a40:	4c 8b bc 24 50 01 00 	mov    r15,QWORD PTR [rsp+0x150]
    1a47:	00 
    1a48:	49 8d 47 ff          	lea    rax,[r15-0x1]
    1a4c:	48 83 f8 63          	cmp    rax,0x63
    1a50:	0f 87 32 03 00 00    	ja     1d88 <main+0x9c8>
    1a56:	48 8b 7c 24 30       	mov    rdi,QWORD PTR [rsp+0x30]
    1a5b:	4d 89 f9             	mov    r9,r15
    1a5e:	b9 20 00 00 00       	mov    ecx,0x20
    1a63:	31 c0                	xor    eax,eax
    1a65:	4c 8d 05 73 16 00 00 	lea    r8,[rip+0x1673]        # 30df <_IO_stdin_used+0xdf>
    1a6c:	ba 01 00 00 00       	mov    edx,0x1
    1a71:	be 20 00 00 00       	mov    esi,0x20
    1a76:	e8 95 f7 ff ff       	call   1210 <__snprintf_chk@plt>
    1a7b:	44 89 bc 24 40 03 00 	mov    DWORD PTR [rsp+0x340],r15d
    1a82:	00 
    1a83:	4c 3b 24 24          	cmp    r12,QWORD PTR [rsp]
    1a87:	0f 84 d5 02 00 00    	je     1d62 <main+0x9a2>
    1a8d:	8b 84 24 40 03 00 00 	mov    eax,DWORD PTR [rsp+0x340]
    1a94:	48 89 ea             	mov    rdx,rbp
    1a97:	4c 89 f6             	mov    rsi,r14
    1a9a:	31 ff                	xor    edi,edi
    1a9c:	66 0f 6f 9c 24 20 03 	movdqa xmm3,XMMWORD PTR [rsp+0x320]
    1aa3:	00 00 
    1aa5:	49 83 c4 01          	add    r12,0x1
    1aa9:	66 0f 6f a4 24 30 03 	movdqa xmm4,XMMWORD PTR [rsp+0x330]
    1ab0:	00 00 
    1ab2:	41 89 44 1d 20       	mov    DWORD PTR [r13+rbx*1+0x20],eax
    1ab7:	41 0f 11 5c 1d 00    	movups XMMWORD PTR [r13+rbx*1+0x0],xmm3
    1abd:	41 0f 11 64 1d 10    	movups XMMWORD PTR [r13+rbx*1+0x10],xmm4
    1ac3:	48 83 c3 24          	add    rbx,0x24
    1ac7:	e8 04 f8 ff ff       	call   12d0 <strtok_r@plt>
    1acc:	49 89 c7             	mov    r15,rax
    1acf:	48 85 c0             	test   rax,rax
    1ad2:	74 39                	je     1b0d <main+0x74d>
    1ad4:	48 8d 35 f3 15 00 00 	lea    rsi,[rip+0x15f3]        # 30ce <_IO_stdin_used+0xce>
    1adb:	4c 89 ff             	mov    rdi,r15
    1ade:	e8 1d f8 ff ff       	call   1300 <strcmp@plt>
    1ae3:	85 c0                	test   eax,eax
    1ae5:	0f 85 14 ff ff ff    	jne    19ff <main+0x63f>
    1aeb:	48 b9 69 6e 72 61 6e 	movabs rcx,0x65676e61726e69
    1af2:	67 65 00 
    1af5:	48 8b 44 24 30       	mov    rax,QWORD PTR [rsp+0x30]
    1afa:	48 89 08             	mov    QWORD PTR [rax],rcx
    1afd:	c7 84 24 40 03 00 00 	mov    DWORD PTR [rsp+0x340],0x0
    1b04:	00 00 00 00 
    1b08:	e9 76 ff ff ff       	jmp    1a83 <main+0x6c3>
    1b0d:	48 8b 7c 24 18       	mov    rdi,QWORD PTR [rsp+0x18]
    1b12:	4c 89 a4 24 00 01 00 	mov    QWORD PTR [rsp+0x100],r12
    1b19:	00 
    1b1a:	4c 89 ac 24 b0 00 00 	mov    QWORD PTR [rsp+0xb0],r13
    1b21:	00 
    1b22:	4c 8b 64 24 38       	mov    r12,QWORD PTR [rsp+0x38]
    1b27:	48 89 84 24 b8 00 00 	mov    QWORD PTR [rsp+0xb8],rax
    1b2e:	00 
    1b2f:	4c 8b 6c 24 20       	mov    r13,QWORD PTR [rsp+0x20]
    1b34:	e8 e7 f6 ff ff       	call   1220 <free@plt>
    1b39:	48 83 bc 24 00 01 00 	cmp    QWORD PTR [rsp+0x100],0x0
    1b40:	00 00 
    1b42:	0f 84 4a 02 00 00    	je     1d92 <main+0x9d2>
    1b48:	48 8b 7c 24 10       	mov    rdi,QWORD PTR [rsp+0x10]
    1b4d:	e8 4e f8 ff ff       	call   13a0 <strdup@plt>
    1b52:	49 89 c7             	mov    r15,rax
    1b55:	48 85 c0             	test   rax,rax
    1b58:	0f 84 c0 01 00 00    	je     1d1e <main+0x95e>
    1b5e:	48 89 ea             	mov    rdx,rbp
    1b61:	4c 89 f6             	mov    rsi,r14
    1b64:	48 89 c7             	mov    rdi,rax
    1b67:	48 c7 84 24 48 01 00 	mov    QWORD PTR [rsp+0x148],0x0
    1b6e:	00 00 00 00 00 
    1b73:	e8 58 f7 ff ff       	call   12d0 <strtok_r@plt>
    1b78:	48 89 c1             	mov    rcx,rax
    1b7b:	48 85 c0             	test   rax,rax
    1b7e:	0f 84 92 01 00 00    	je     1d16 <main+0x956>
    1b84:	48 c7 44 24 10 00 00 	mov    QWORD PTR [rsp+0x10],0x0
    1b8b:	00 00 
    1b8d:	31 c0                	xor    eax,eax
    1b8f:	4c 89 6c 24 20       	mov    QWORD PTR [rsp+0x20],r13
    1b94:	4c 89 64 24 38       	mov    QWORD PTR [rsp+0x38],r12
    1b99:	49 89 c4             	mov    r12,rax
    1b9c:	4c 89 3c 24          	mov    QWORD PTR [rsp],r15
    1ba0:	49 89 cf             	mov    r15,rcx
    1ba3:	41 80 3f 00          	cmp    BYTE PTR [r15],0x0
    1ba7:	0f 84 65 01 00 00    	je     1d12 <main+0x952>
    1bad:	e8 8e f6 ff ff       	call   1240 <__errno_location@plt>
    1bb2:	48 8b b4 24 c0 00 00 	mov    rsi,QWORD PTR [rsp+0xc0]
    1bb9:	00 
    1bba:	ba 0a 00 00 00       	mov    edx,0xa
    1bbf:	4c 89 ff             	mov    rdi,r15
    1bc2:	c7 00 00 00 00 00    	mov    DWORD PTR [rax],0x0
    1bc8:	49 89 c5             	mov    r13,rax
    1bcb:	48 89 44 24 18       	mov    QWORD PTR [rsp+0x18],rax
    1bd0:	48 c7 84 24 50 01 00 	mov    QWORD PTR [rsp+0x150],0x0
    1bd7:	00 00 00 00 00 
    1bdc:	e8 0f f7 ff ff       	call   12f0 <strtoull@plt>
    1be1:	48 89 c3             	mov    rbx,rax
    1be4:	41 8b 45 00          	mov    eax,DWORD PTR [r13+0x0]
    1be8:	85 c0                	test   eax,eax
    1bea:	0f 85 22 01 00 00    	jne    1d12 <main+0x952>
    1bf0:	4c 8b ac 24 50 01 00 	mov    r13,QWORD PTR [rsp+0x150]
    1bf7:	00 
    1bf8:	4d 39 fd             	cmp    r13,r15
    1bfb:	0f 84 11 01 00 00    	je     1d12 <main+0x952>
    1c01:	41 80 7d 00 00       	cmp    BYTE PTR [r13+0x0],0x0
    1c06:	0f 84 c2 00 00 00    	je     1cce <main+0x90e>
    1c0c:	48 8d 35 e5 14 00 00 	lea    rsi,[rip+0x14e5]        # 30f8 <_IO_stdin_used+0xf8>
    1c13:	4c 89 ef             	mov    rdi,r13
    1c16:	e8 15 f6 ff ff       	call   1230 <strcasecmp@plt>
    1c1b:	85 c0                	test   eax,eax
    1c1d:	0f 84 ab 00 00 00    	je     1cce <main+0x90e>
    1c23:	48 8d 35 4e 14 00 00 	lea    rsi,[rip+0x144e]        # 3078 <_IO_stdin_used+0x78>
    1c2a:	4c 89 ef             	mov    rdi,r13
    1c2d:	e8 fe f5 ff ff       	call   1230 <strcasecmp@plt>
    1c32:	85 c0                	test   eax,eax
    1c34:	0f 84 8d 00 00 00    	je     1cc7 <main+0x907>
    1c3a:	48 8d 35 ab 14 00 00 	lea    rsi,[rip+0x14ab]        # 30ec <_IO_stdin_used+0xec>
    1c41:	4c 89 ef             	mov    rdi,r13
    1c44:	e8 e7 f5 ff ff       	call   1230 <strcasecmp@plt>
    1c49:	85 c0                	test   eax,eax
    1c4b:	74 7a                	je     1cc7 <main+0x907>
    1c4d:	48 8d 35 9c 14 00 00 	lea    rsi,[rip+0x149c]        # 30f0 <_IO_stdin_used+0xf0>
    1c54:	4c 89 ef             	mov    rdi,r13
    1c57:	e8 d4 f5 ff ff       	call   1230 <strcasecmp@plt>
    1c5c:	85 c0                	test   eax,eax
    1c5e:	0f 85 00 0d 00 00    	jne    2964 <main+0x15a4>
    1c64:	b9 00 00 10 00       	mov    ecx,0x100000
    1c69:	48 89 d8             	mov    rax,rbx
    1c6c:	48 f7 e1             	mul    rcx
    1c6f:	0f 80 9d 00 00 00    	jo     1d12 <main+0x952>
    1c75:	48 0f af d9          	imul   rbx,rcx
    1c79:	48 83 fb 3f          	cmp    rbx,0x3f
    1c7d:	0f 86 8f 00 00 00    	jbe    1d12 <main+0x952>
    1c83:	4c 3b 64 24 10       	cmp    r12,QWORD PTR [rsp+0x10]
    1c88:	74 4b                	je     1cd5 <main+0x915>
    1c8a:	48 8b 84 24 b8 00 00 	mov    rax,QWORD PTR [rsp+0xb8]
    1c91:	00 
    1c92:	31 ff                	xor    edi,edi
    1c94:	48 89 ea             	mov    rdx,rbp
    1c97:	4c 89 f6             	mov    rsi,r14
    1c9a:	4d 8d 44 24 01       	lea    r8,[r12+0x1]
    1c9f:	4a 89 5c c0 f8       	mov    QWORD PTR [rax+r8*8-0x8],rbx
    1ca4:	4c 89 44 24 40       	mov    QWORD PTR [rsp+0x40],r8
    1ca9:	e8 22 f6 ff ff       	call   12d0 <strtok_r@plt>
    1cae:	4c 8b 44 24 40       	mov    r8,QWORD PTR [rsp+0x40]
    1cb3:	48 85 c0             	test   rax,rax
    1cb6:	49 89 c7             	mov    r15,rax
    1cb9:	0f 84 c7 01 00 00    	je     1e86 <main+0xac6>
    1cbf:	4d 89 c4             	mov    r12,r8
    1cc2:	e9 dc fe ff ff       	jmp    1ba3 <main+0x7e3>
    1cc7:	b9 00 04 00 00       	mov    ecx,0x400
    1ccc:	eb 9b                	jmp    1c69 <main+0x8a9>
    1cce:	b9 01 00 00 00       	mov    ecx,0x1
    1cd3:	eb a0                	jmp    1c75 <main+0x8b5>
    1cd5:	4d 85 e4             	test   r12,r12
    1cd8:	0f 84 06 01 00 00    	je     1de4 <main+0xa24>
    1cde:	4b 8d 04 24          	lea    rax,[r12+r12*1]
    1ce2:	48 89 44 24 10       	mov    QWORD PTR [rsp+0x10],rax
    1ce7:	48 8b 44 24 10       	mov    rax,QWORD PTR [rsp+0x10]
    1cec:	48 8b bc 24 b8 00 00 	mov    rdi,QWORD PTR [rsp+0xb8]
    1cf3:	00 
    1cf4:	48 8d 34 c5 00 00 00 	lea    rsi,[rax*8+0x0]
    1cfb:	00 
    1cfc:	e8 2f f6 ff ff       	call   1330 <realloc@plt>
    1d01:	48 89 84 24 b8 00 00 	mov    QWORD PTR [rsp+0xb8],rax
    1d08:	00 
    1d09:	48 85 c0             	test   rax,rax
    1d0c:	0f 85 78 ff ff ff    	jne    1c8a <main+0x8ca>
    1d12:	4c 8b 3c 24          	mov    r15,QWORD PTR [rsp]
    1d16:	4c 89 ff             	mov    rdi,r15
    1d19:	e8 02 f5 ff ff       	call   1220 <free@plt>
    1d1e:	48 8b 3d 1b 33 00 00 	mov    rdi,QWORD PTR [rip+0x331b]        # 5040 <stderr@GLIBC_2.2.5>
    1d25:	48 8d 15 7c 19 00 00 	lea    rdx,[rip+0x197c]        # 36a8 <_IO_stdin_used+0x6a8>
    1d2c:	be 01 00 00 00       	mov    esi,0x1
    1d31:	31 c0                	xor    eax,eax
    1d33:	e8 48 f6 ff ff       	call   1380 <__fprintf_chk@plt>
    1d38:	48 8b bc 24 c8 00 00 	mov    rdi,QWORD PTR [rsp+0xc8]
    1d3f:	00 
    1d40:	e8 db f4 ff ff       	call   1220 <free@plt>
    1d45:	48 8b bc 24 b0 00 00 	mov    rdi,QWORD PTR [rsp+0xb0]
    1d4c:	00 
    1d4d:	e8 ce f4 ff ff       	call   1220 <free@plt>
    1d52:	c7 84 24 9c 00 00 00 	mov    DWORD PTR [rsp+0x9c],0x2
    1d59:	02 00 00 00 
    1d5d:	e9 c0 fb ff ff       	jmp    1922 <main+0x562>
    1d62:	4d 85 e4             	test   r12,r12
    1d65:	74 62                	je     1dc9 <main+0xa09>
    1d67:	4b 8d 04 24          	lea    rax,[r12+r12*1]
    1d6b:	48 89 04 24          	mov    QWORD PTR [rsp],rax
    1d6f:	48 6b 34 24 24       	imul   rsi,QWORD PTR [rsp],0x24
    1d74:	4c 89 ef             	mov    rdi,r13
    1d77:	e8 b4 f5 ff ff       	call   1330 <realloc@plt>
    1d7c:	49 89 c5             	mov    r13,rax
    1d7f:	48 85 c0             	test   rax,rax
    1d82:	0f 85 05 fd ff ff    	jne    1a8d <main+0x6cd>
    1d88:	48 8b 7c 24 18       	mov    rdi,QWORD PTR [rsp+0x18]
    1d8d:	e8 8e f4 ff ff       	call   1220 <free@plt>
    1d92:	48 8b 3d a7 32 00 00 	mov    rdi,QWORD PTR [rip+0x32a7]        # 5040 <stderr@GLIBC_2.2.5>
    1d99:	48 8d 15 c0 18 00 00 	lea    rdx,[rip+0x18c0]        # 3660 <_IO_stdin_used+0x660>
    1da0:	be 01 00 00 00       	mov    esi,0x1
    1da5:	31 c0                	xor    eax,eax
    1da7:	e8 d4 f5 ff ff       	call   1380 <__fprintf_chk@plt>
    1dac:	48 8b bc 24 c8 00 00 	mov    rdi,QWORD PTR [rsp+0xc8]
    1db3:	00 
    1db4:	e8 67 f4 ff ff       	call   1220 <free@plt>
    1db9:	c7 84 24 9c 00 00 00 	mov    DWORD PTR [rsp+0x9c],0x2
    1dc0:	02 00 00 00 
    1dc4:	e9 59 fb ff ff       	jmp    1922 <main+0x562>
    1dc9:	48 c7 04 24 08 00 00 	mov    QWORD PTR [rsp],0x8
    1dd0:	00 
    1dd1:	eb 9c                	jmp    1d6f <main+0x9af>
    1dd3:	48 c7 84 24 40 01 00 	mov    QWORD PTR [rsp+0x140],0x1
    1dda:	00 01 00 00 00 
    1ddf:	e9 9e f7 ff ff       	jmp    1582 <main+0x1c2>
    1de4:	48 c7 44 24 10 10 00 	mov    QWORD PTR [rsp+0x10],0x10
    1deb:	00 00 
    1ded:	e9 f5 fe ff ff       	jmp    1ce7 <main+0x927>
    1df2:	48 8d 15 ff 17 00 00 	lea    rdx,[rip+0x17ff]        # 35f8 <_IO_stdin_used+0x5f8>
    1df9:	e9 b8 f8 ff ff       	jmp    16b6 <main+0x2f6>
    1dfe:	48 8d 15 c3 17 00 00 	lea    rdx,[rip+0x17c3]        # 35c8 <_IO_stdin_used+0x5c8>
    1e05:	e9 ac f8 ff ff       	jmp    16b6 <main+0x2f6>
    1e0a:	48 8d 05 19 12 00 00 	lea    rax,[rip+0x1219]        # 302a <_IO_stdin_used+0x2a>
    1e11:	41 bd 40 0d 03 00    	mov    r13d,0x30d40
    1e17:	4c 8d 3d f9 11 00 00 	lea    r15,[rip+0x11f9]        # 3017 <_IO_stdin_used+0x17>
    1e1e:	45 31 e4             	xor    r12d,r12d
    1e21:	48 89 44 24 10       	mov    QWORD PTR [rsp+0x10],rax
    1e26:	48 8d 05 3b 13 00 00 	lea    rax,[rip+0x133b]        # 3168 <_IO_stdin_used+0x168>
    1e2d:	48 c7 84 24 a0 00 00 	mov    QWORD PTR [rsp+0xa0],0x5
    1e34:	00 05 00 00 00 
    1e39:	48 89 04 24          	mov    QWORD PTR [rsp],rax
    1e3d:	48 c7 44 24 08 00 00 	mov    QWORD PTR [rsp+0x8],0x0
    1e44:	00 00 
    1e46:	e9 0b f7 ff ff       	jmp    1556 <main+0x196>
    1e4b:	48 8b 3d ee 31 00 00 	mov    rdi,QWORD PTR [rip+0x31ee]        # 5040 <stderr@GLIBC_2.2.5>
    1e52:	4c 89 f1             	mov    rcx,r14
    1e55:	be 01 00 00 00       	mov    esi,0x1
    1e5a:	31 c0                	xor    eax,eax
    1e5c:	48 8d 15 35 17 00 00 	lea    rdx,[rip+0x1735]        # 3598 <_IO_stdin_used+0x598>
    1e63:	e8 18 f5 ff ff       	call   1380 <__fprintf_chk@plt>
    1e68:	48 8b 7d 00          	mov    rdi,QWORD PTR [rbp+0x0]
    1e6c:	e8 9f 10 00 00       	call   2f10 <usage>
    1e71:	c7 84 24 9c 00 00 00 	mov    DWORD PTR [rsp+0x9c],0x2
    1e78:	02 00 00 00 
    1e7c:	e9 a1 fa ff ff       	jmp    1922 <main+0x562>
    1e81:	e8 fa f3 ff ff       	call   1280 <__stack_chk_fail@plt>
    1e86:	4c 8b 3c 24          	mov    r15,QWORD PTR [rsp]
    1e8a:	4c 89 c3             	mov    rbx,r8
    1e8d:	4c 8b 6c 24 20       	mov    r13,QWORD PTR [rsp+0x20]
    1e92:	4c 89 a4 24 18 01 00 	mov    QWORD PTR [rsp+0x118],r12
    1e99:	00 
    1e9a:	4c 8b 64 24 38       	mov    r12,QWORD PTR [rsp+0x38]
    1e9f:	4c 89 ff             	mov    rdi,r15
    1ea2:	e8 79 f3 ff ff       	call   1220 <free@plt>
    1ea7:	48 85 db             	test   rbx,rbx
    1eaa:	0f 84 6e fe ff ff    	je     1d1e <main+0x95e>
    1eb0:	48 8b 44 24 28       	mov    rax,QWORD PTR [rsp+0x28]
    1eb5:	48 85 c0             	test   rax,rax
    1eb8:	74 05                	je     1ebf <main+0xaff>
    1eba:	80 38 00             	cmp    BYTE PTR [rax],0x0
    1ebd:	75 0c                	jne    1ecb <main+0xb0b>
    1ebf:	48 8d 05 72 11 00 00 	lea    rax,[rip+0x1172]        # 3038 <_IO_stdin_used+0x38>
    1ec6:	48 89 44 24 28       	mov    QWORD PTR [rsp+0x28],rax
    1ecb:	31 ff                	xor    edi,edi
    1ecd:	e8 3e f4 ff ff       	call   1310 <time@plt>
    1ed2:	48 8b b4 24 c0 00 00 	mov    rsi,QWORD PTR [rsp+0xc0]
    1ed9:	00 
    1eda:	48 89 ef             	mov    rdi,rbp
    1edd:	48 89 84 24 48 01 00 	mov    QWORD PTR [rsp+0x148],rax
    1ee4:	00 
    1ee5:	e8 c6 f3 ff ff       	call   12b0 <gmtime_r@plt>
    1eea:	48 85 c0             	test   rax,rax
    1eed:	74 26                	je     1f15 <main+0xb55>
    1eef:	48 8b 8c 24 c0 00 00 	mov    rcx,QWORD PTR [rsp+0xc0]
    1ef6:	00 
    1ef7:	48 8d bc 24 a0 05 00 	lea    rdi,[rsp+0x5a0]
    1efe:	00 
    1eff:	be 20 00 00 00       	mov    esi,0x20
    1f04:	48 8d 15 ef 11 00 00 	lea    rdx,[rip+0x11ef]        # 30fa <_IO_stdin_used+0xfa>
    1f0b:	e8 30 f4 ff ff       	call   1340 <strftime@plt>
    1f10:	48 85 c0             	test   rax,rax
    1f13:	75 12                	jne    1f27 <main+0xb67>
    1f15:	48 b8 75 6e 6b 6e 6f 	movabs rax,0x6e776f6e6b6e75
    1f1c:	77 6e 00 
    1f1f:	48 89 84 24 a0 05 00 	mov    QWORD PTR [rsp+0x5a0],rax
    1f26:	00 
    1f27:	e8 34 f4 ff ff       	call   1360 <sched_getcpu@plt>
    1f2c:	48 8b 7c 24 30       	mov    rdi,QWORD PTR [rsp+0x30]
    1f31:	b9 50 00 00 00       	mov    ecx,0x50
    1f36:	89 84 24 98 00 00 00 	mov    DWORD PTR [rsp+0x98],eax
    1f3d:	31 c0                	xor    eax,eax
    1f3f:	f3 48 ab             	rep stos QWORD PTR es:[rdi],rax
    1f42:	4d 85 e4             	test   r12,r12
    1f45:	74 07                	je     1f4e <main+0xb8e>
    1f47:	41 80 3c 24 00       	cmp    BYTE PTR [r12],0x0
    1f4c:	75 20                	jne    1f6e <main+0xbae>
    1f4e:	48 8d 3d b8 11 00 00 	lea    rdi,[rip+0x11b8]        # 310d <_IO_stdin_used+0x10d>
    1f55:	e8 a6 f2 ff ff       	call   1200 <getenv@plt>
    1f5a:	49 89 c4             	mov    r12,rax
    1f5d:	48 85 c0             	test   rax,rax
    1f60:	74 05                	je     1f67 <main+0xba7>
    1f62:	80 38 00             	cmp    BYTE PTR [rax],0x0
    1f65:	75 07                	jne    1f6e <main+0xbae>
    1f67:	4c 8d 25 d1 10 00 00 	lea    r12,[rip+0x10d1]        # 303f <_IO_stdin_used+0x3f>
    1f6e:	48 8b 7c 24 30       	mov    rdi,QWORD PTR [rsp+0x30]
    1f73:	4c 89 e1             	mov    rcx,r12
    1f76:	be 40 00 00 00       	mov    esi,0x40
    1f7b:	31 c0                	xor    eax,eax
    1f7d:	4c 8d 25 90 10 00 00 	lea    r12,[rip+0x1090]        # 3014 <_IO_stdin_used+0x14>
    1f84:	4c 89 e2             	mov    rdx,r12
    1f87:	e8 04 f3 ff ff       	call   1290 <snprintf@plt>
    1f8c:	48 8d b4 24 60 03 00 	lea    rsi,[rsp+0x360]
    1f93:	00 
    1f94:	ba 80 00 00 00       	mov    edx,0x80
    1f99:	48 8d 3d 78 11 00 00 	lea    rdi,[rip+0x1178]        # 3118 <_IO_stdin_used+0x118>
    1fa0:	e8 db 0d 00 00       	call   2d80 <read_cpuinfo_field>
    1fa5:	85 c0                	test   eax,eax
    1fa7:	0f 85 11 09 00 00    	jne    28be <main+0x14fe>
    1fad:	48 8d b4 24 e0 03 00 	lea    rsi,[rsp+0x3e0]
    1fb4:	00 
    1fb5:	ba 20 00 00 00       	mov    edx,0x20
    1fba:	48 8d 3d 62 11 00 00 	lea    rdi,[rip+0x1162]        # 3123 <_IO_stdin_used+0x123>
    1fc1:	e8 ba 0d 00 00       	call   2d80 <read_cpuinfo_field>
    1fc6:	85 c0                	test   eax,eax
    1fc8:	0f 85 d9 08 00 00    	jne    28a7 <main+0x14e7>
    1fce:	48 8d b4 24 00 04 00 	lea    rsi,[rsp+0x400]
    1fd5:	00 
    1fd6:	ba 20 00 00 00       	mov    edx,0x20
    1fdb:	48 8d 3d 4c 11 00 00 	lea    rdi,[rip+0x114c]        # 312e <_IO_stdin_used+0x12e>
    1fe2:	e8 99 0d 00 00       	call   2d80 <read_cpuinfo_field>
    1fe7:	85 c0                	test   eax,eax
    1fe9:	0f 85 a1 08 00 00    	jne    2890 <main+0x14d0>
    1fef:	48 8d b4 24 20 04 00 	lea    rsi,[rsp+0x420]
    1ff6:	00 
    1ff7:	ba 20 00 00 00       	mov    edx,0x20
    1ffc:	48 8d 3d 31 11 00 00 	lea    rdi,[rip+0x1131]        # 3134 <_IO_stdin_used+0x134>
    2003:	e8 78 0d 00 00       	call   2d80 <read_cpuinfo_field>
    2008:	85 c0                	test   eax,eax
    200a:	0f 85 69 08 00 00    	jne    2879 <main+0x14b9>
    2010:	48 8d b4 24 40 04 00 	lea    rsi,[rsp+0x440]
    2017:	00 
    2018:	ba 20 00 00 00       	mov    edx,0x20
    201d:	48 8d 3d 19 11 00 00 	lea    rdi,[rip+0x1119]        # 313d <_IO_stdin_used+0x13d>
    2024:	e8 57 0d 00 00       	call   2d80 <read_cpuinfo_field>
    2029:	85 c0                	test   eax,eax
    202b:	0f 85 31 08 00 00    	jne    2862 <main+0x14a2>
    2031:	48 8d 84 24 90 01 00 	lea    rax,[rsp+0x190]
    2038:	00 
    2039:	48 89 c7             	mov    rdi,rax
    203c:	48 89 84 24 88 00 00 	mov    QWORD PTR [rsp+0x88],rax
    2043:	00 
    2044:	e8 57 f2 ff ff       	call   12a0 <uname@plt>
    2049:	85 c0                	test   eax,eax
    204b:	0f 85 fa 07 00 00    	jne    284b <main+0x148b>
    2051:	48 8d 8c 24 12 02 00 	lea    rcx,[rsp+0x212]
    2058:	00 
    2059:	48 8d bc 24 60 04 00 	lea    rdi,[rsp+0x460]
    2060:	00 
    2061:	4c 89 e2             	mov    rdx,r12
    2064:	be 80 00 00 00       	mov    esi,0x80
    2069:	e8 22 f2 ff ff       	call   1290 <snprintf@plt>
    206e:	48 8d 84 24 e0 04 00 	lea    rax,[rsp+0x4e0]
    2075:	00 
    2076:	48 8d 35 ca 10 00 00 	lea    rsi,[rip+0x10ca]        # 3147 <_IO_stdin_used+0x147>
    207d:	b9 07 00 00 00       	mov    ecx,0x7
    2082:	4c 8b 3d 97 2f 00 00 	mov    r15,QWORD PTR [rip+0x2f97]        # 5020 <stdout@GLIBC_2.2.5>
    2089:	48 89 c7             	mov    rdi,rax
    208c:	48 8d 84 24 20 05 00 	lea    rax,[rsp+0x520]
    2093:	00 
    2094:	f3 a4                	rep movs BYTE PTR es:[rdi],BYTE PTR ds:[rsi]
    2096:	48 8d 35 43 16 00 00 	lea    rsi,[rip+0x1643]        # 36e0 <_IO_stdin_used+0x6e0>
    209d:	b9 31 00 00 00       	mov    ecx,0x31
    20a2:	48 89 c7             	mov    rdi,rax
    20a5:	f3 a4                	rep movs BYTE PTR es:[rdi],BYTE PTR ds:[rsi]
    20a7:	48 8b 7c 24 08       	mov    rdi,QWORD PTR [rsp+0x8]
    20ac:	48 85 ff             	test   rdi,rdi
    20af:	74 14                	je     20c5 <main+0xd05>
    20b1:	48 8d 35 96 10 00 00 	lea    rsi,[rip+0x1096]        # 314e <_IO_stdin_used+0x14e>
    20b8:	e8 43 f2 ff ff       	call   1300 <strcmp@plt>
    20bd:	85 c0                	test   eax,eax
    20bf:	0f 85 10 08 00 00    	jne    28d5 <main+0x1515>
    20c5:	4c 89 f9             	mov    rcx,r15
    20c8:	ba b8 00 00 00       	mov    edx,0xb8
    20cd:	be 01 00 00 00       	mov    esi,0x1
    20d2:	48 8d 3d 5f 16 00 00 	lea    rdi,[rip+0x165f]        # 3738 <_IO_stdin_used+0x738>
    20d9:	e8 92 f2 ff ff       	call   1370 <fwrite@plt>
    20de:	4a 8d 04 ed 00 00 00 	lea    rax,[r13*8+0x0]
    20e5:	00 
    20e6:	48 8b 5c 24 78       	mov    rbx,QWORD PTR [rsp+0x78]
    20eb:	31 d2                	xor    edx,edx
    20ed:	48 89 84 24 10 01 00 	mov    QWORD PTR [rsp+0x110],rax
    20f4:	00 
    20f5:	48 8b 84 24 b0 00 00 	mov    rax,QWORD PTR [rsp+0xb0]
    20fc:	00 
    20fd:	48 b9 2a f8 94 fe 72 	movabs rcx,0x3c6ef372fe94f82a
    2104:	f3 6e 3c 
    2107:	48 c7 84 24 f0 00 00 	mov    QWORD PTR [rsp+0xf0],0x0
    210e:	00 00 00 00 00 
    2113:	48 89 44 24 38       	mov    QWORD PTR [rsp+0x38],rax
    2118:	48 b8 2a f8 94 fe 72 	movabs rax,0x3c6ef372fe94f82a
    211f:	f3 6e 3c 
    2122:	48 c7 84 24 f8 00 00 	mov    QWORD PTR [rsp+0xf8],0x0
    2129:	00 00 00 00 00 
    212e:	48 0f af c3          	imul   rax,rbx
    2132:	48 29 c8             	sub    rax,rcx
    2135:	48 85 db             	test   rbx,rbx
    2138:	48 0f 44 c2          	cmove  rax,rdx
    213c:	48 01 c8             	add    rax,rcx
    213f:	48 89 84 24 a8 00 00 	mov    QWORD PTR [rsp+0xa8],rax
    2146:	00 
    2147:	48 c7 84 24 e8 00 00 	mov    QWORD PTR [rsp+0xe8],0x0
    214e:	00 00 00 00 00 
    2153:	4c 89 f8             	mov    rax,r15
    2156:	4d 89 ef             	mov    r15,r13
    2159:	49 89 c5             	mov    r13,rax
    215c:	48 8b 84 24 b8 00 00 	mov    rax,QWORD PTR [rsp+0xb8]
    2163:	00 
    2164:	48 8b 9c 24 e8 00 00 	mov    rbx,QWORD PTR [rsp+0xe8]
    216b:	00 
    216c:	4c 8b 34 d8          	mov    r14,QWORD PTR [rax+rbx*8]
    2170:	4d 85 f6             	test   r14,r14
    2173:	0f 88 a2 06 00 00    	js     281b <main+0x145b>
    2179:	48 8b bc 24 c0 00 00 	mov    rdi,QWORD PTR [rsp+0xc0]
    2180:	00 
    2181:	4b 8d 1c 36          	lea    rbx,[r14+r14*1]
    2185:	be 40 00 00 00       	mov    esi,0x40
    218a:	48 c7 84 24 50 01 00 	mov    QWORD PTR [rsp+0x150],0x0
    2191:	00 00 00 00 00 
    2196:	48 89 da             	mov    rdx,rbx
    2199:	e8 f2 f1 ff ff       	call   1390 <posix_memalign@plt>
    219e:	89 84 24 9c 00 00 00 	mov    DWORD PTR [rsp+0x9c],eax
    21a5:	85 c0                	test   eax,eax
    21a7:	0f 85 3e 06 00 00    	jne    27eb <main+0x142b>
    21ad:	48 8b 8c 24 50 01 00 	mov    rcx,QWORD PTR [rsp+0x150]
    21b4:	00 
    21b5:	48 85 c9             	test   rcx,rcx
    21b8:	0f 84 2d 06 00 00    	je     27eb <main+0x142b>
    21be:	48 85 db             	test   rbx,rbx
    21c1:	74 20                	je     21e3 <main+0xe23>
    21c3:	ba 07 00 00 00       	mov    edx,0x7
    21c8:	31 c0                	xor    eax,eax
    21ca:	eb 08                	jmp    21d4 <main+0xe14>
    21cc:	48 8b 8c 24 50 01 00 	mov    rcx,QWORD PTR [rsp+0x150]
    21d3:	00 
    21d4:	88 14 01             	mov    BYTE PTR [rcx+rax*1],dl
    21d7:	48 83 c0 01          	add    rax,0x1
    21db:	83 ea 7d             	sub    edx,0x7d
    21de:	48 39 c3             	cmp    rbx,rax
    21e1:	75 e9                	jne    21cc <main+0xe0c>
    21e3:	48 8b bc 24 10 01 00 	mov    rdi,QWORD PTR [rsp+0x110]
    21ea:	00 
    21eb:	e8 30 f1 ff ff       	call   1320 <malloc@plt>
    21f0:	49 89 c4             	mov    r12,rax
    21f3:	48 85 c0             	test   rax,rax
    21f6:	0f 84 b8 05 00 00    	je     27b4 <main+0x13f4>
    21fc:	48 8b bc 24 38 01 00 	mov    rdi,QWORD PTR [rsp+0x138]
    2203:	00 
    2204:	48 8b 44 24 38       	mov    rax,QWORD PTR [rsp+0x38]
    2209:	45 31 c0             	xor    r8d,r8d
    220c:	31 c9                	xor    ecx,ecx
    220e:	49 bb b9 e5 e4 1c 6d 	movabs r11,0xbf58476d1ce4e5b9
    2215:	47 58 bf 
    2218:	48 bb eb 11 31 13 bb 	movabs rbx,0x94d049bb133111eb
    221f:	49 d0 94 
    2222:	48 bd 15 7c 4a 7f b9 	movabs rbp,0x9e3779b97f4a7c15
    2229:	79 37 9e 
    222c:	48 89 7c 24 40       	mov    QWORD PTR [rsp+0x40],rdi
    2231:	44 8b 50 20          	mov    r10d,DWORD PTR [rax+0x20]
    2235:	48 b8 2a f8 94 fe 72 	movabs rax,0x3c6ef372fe94f82a
    223c:	f3 6e 3c 
    223f:	48 89 fe             	mov    rsi,rdi
    2242:	48 01 c7             	add    rdi,rax
    2245:	48 89 fa             	mov    rdx,rdi
    2248:	48 c1 ea 1e          	shr    rdx,0x1e
    224c:	48 31 fa             	xor    rdx,rdi
    224f:	49 0f af d3          	imul   rdx,r11
    2253:	48 89 d0             	mov    rax,rdx
    2256:	48 c1 e8 1b          	shr    rax,0x1b
    225a:	48 31 d0             	xor    rax,rdx
    225d:	48 0f af c3          	imul   rax,rbx
    2261:	48 89 c2             	mov    rdx,rax
    2264:	48 c1 ea 1f          	shr    rdx,0x1f
    2268:	48 31 d0             	xor    rax,rdx
    226b:	31 d2                	xor    edx,edx
    226d:	49 f7 f6             	div    r14
    2270:	49 89 d1             	mov    r9,rdx
    2273:	45 85 d2             	test   r10d,r10d
    2276:	7e 62                	jle    22da <main+0xf1a>
    2278:	48 01 ee             	add    rsi,rbp
    227b:	48 89 f2             	mov    rdx,rsi
    227e:	48 c1 ea 1e          	shr    rdx,0x1e
    2282:	48 31 f2             	xor    rdx,rsi
    2285:	49 0f af d3          	imul   rdx,r11
    2289:	48 89 d0             	mov    rax,rdx
    228c:	48 c1 e8 1b          	shr    rax,0x1b
    2290:	48 31 d0             	xor    rax,rdx
    2293:	48 0f af c3          	imul   rax,rbx
    2297:	48 89 c6             	mov    rsi,rax
    229a:	48 c1 ee 1f          	shr    rsi,0x1f
    229e:	48 31 c6             	xor    rsi,rax
    22a1:	48 b8 c3 f5 28 5c 8f 	movabs rax,0x28f5c28f5c28f5c3
    22a8:	c2 f5 28 
    22ab:	48 89 f2             	mov    rdx,rsi
    22ae:	48 c1 ea 02          	shr    rdx,0x2
    22b2:	48 f7 e2             	mul    rdx
    22b5:	48 89 d0             	mov    rax,rdx
    22b8:	48 83 e2 fc          	and    rdx,0xfffffffffffffffc
    22bc:	48 c1 e8 02          	shr    rax,0x2
    22c0:	48 01 d0             	add    rax,rdx
    22c3:	48 8d 04 80          	lea    rax,[rax+rax*4]
    22c7:	48 c1 e0 02          	shl    rax,0x2
    22cb:	48 29 c6             	sub    rsi,rax
    22ce:	41 39 f2             	cmp    r10d,esi
    22d1:	7e 07                	jle    22da <main+0xf1a>
    22d3:	48 83 c1 01          	add    rcx,0x1
    22d7:	4d 01 f1             	add    r9,r14
    22da:	4f 89 0c c4          	mov    QWORD PTR [r12+r8*8],r9
    22de:	49 83 c0 01          	add    r8,0x1
    22e2:	4d 39 f8             	cmp    r8,r15
    22e5:	0f 82 4a ff ff ff    	jb     2235 <main+0xe75>
    22eb:	66 0f ef ed          	pxor   xmm5,xmm5
    22ef:	f2 49 0f 2a ef       	cvtsi2sd xmm5,r15
    22f4:	f2 0f 11 6c 24 48    	movsd  QWORD PTR [rsp+0x48],xmm5
    22fa:	48 85 c9             	test   rcx,rcx
    22fd:	0f 88 2e 04 00 00    	js     2731 <main+0x1371>
    2303:	66 0f ef c0          	pxor   xmm0,xmm0
    2307:	f2 48 0f 2a c1       	cvtsi2sd xmm0,rcx
    230c:	48 8b 84 24 f8 00 00 	mov    rax,QWORD PTR [rsp+0xf8]
    2313:	00 
    2314:	4c 89 a4 24 80 00 00 	mov    QWORD PTR [rsp+0x80],r12
    231b:	00 
    231c:	f2 0f 5e 44 24 48    	divsd  xmm0,QWORD PTR [rsp+0x48]
    2322:	48 c7 84 24 d8 00 00 	mov    QWORD PTR [rsp+0xd8],0x0
    2329:	00 00 00 00 00 
    232e:	48 8d 50 01          	lea    rdx,[rax+0x1]
    2332:	f2 0f 11 44 24 58    	movsd  QWORD PTR [rsp+0x58],xmm0
    2338:	48 b8 b9 e5 e4 1c 6d 	movabs rax,0xbf58476d1ce4e5b9
    233f:	47 58 bf 
    2342:	48 0f af d0          	imul   rdx,rax
    2346:	48 8d 84 24 a0 05 00 	lea    rax,[rsp+0x5a0]
    234d:	00 
    234e:	48 89 44 24 68       	mov    QWORD PTR [rsp+0x68],rax
    2353:	48 8d 84 24 9c 01 00 	lea    rax,[rsp+0x19c]
    235a:	00 
    235b:	48 89 44 24 60       	mov    QWORD PTR [rsp+0x60],rax
    2360:	4c 89 f0             	mov    rax,r14
    2363:	4d 89 ee             	mov    r14,r13
    2366:	48 89 94 24 08 01 00 	mov    QWORD PTR [rsp+0x108],rdx
    236d:	00 
    236e:	49 89 c5             	mov    r13,rax
    2371:	48 8b 84 24 c8 00 00 	mov    rax,QWORD PTR [rsp+0xc8]
    2378:	00 
    2379:	48 8b 9c 24 d8 00 00 	mov    rbx,QWORD PTR [rsp+0xd8]
    2380:	00 
    2381:	48 b9 15 7c 4a 7f b9 	movabs rcx,0x9e3779b97f4a7c15
    2388:	79 37 9e 
    238b:	48 c7 44 24 20 00 00 	mov    QWORD PTR [rsp+0x20],0x0
    2392:	00 00 
    2394:	48 8b 1c d8          	mov    rbx,QWORD PTR [rax+rbx*8]
    2398:	48 8b 44 24 40       	mov    rax,QWORD PTR [rsp+0x40]
    239d:	48 33 84 24 08 01 00 	xor    rax,QWORD PTR [rsp+0x108]
    23a4:	00 
    23a5:	48 31 c1             	xor    rcx,rax
    23a8:	48 89 5c 24 50       	mov    QWORD PTR [rsp+0x50],rbx
    23ad:	48 89 8c 24 90 00 00 	mov    QWORD PTR [rsp+0x90],rcx
    23b4:	00 
    23b5:	89 5c 24 08          	mov    DWORD PTR [rsp+0x8],ebx
    23b9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    23c0:	48 8b 84 24 90 00 00 	mov    rax,QWORD PTR [rsp+0x90]
    23c7:	00 
    23c8:	48 c7 04 24 00 00 00 	mov    QWORD PTR [rsp],0x0
    23cf:	00 
    23d0:	48 89 44 24 70       	mov    QWORD PTR [rsp+0x70],rax
    23d5:	0f 1f 00             	nop    DWORD PTR [rax]
    23d8:	48 8b 5c 24 70       	mov    rbx,QWORD PTR [rsp+0x70]
    23dd:	48 b8 00 00 00 00 01 	movabs rax,0x100000000
    23e4:	00 00 00 
    23e7:	48 bf b9 e5 e4 1c 6d 	movabs rdi,0xbf58476d1ce4e5b9
    23ee:	47 58 bf 
    23f1:	49 bb eb 11 31 13 bb 	movabs r11,0x94d049bb133111eb
    23f8:	49 d0 94 
    23fb:	48 89 84 24 90 01 00 	mov    QWORD PTR [rsp+0x190],rax
    2402:	00 
    2403:	48 b8 15 7c 4a 7f b9 	movabs rax,0x9e3779b97f4a7c15
    240a:	79 37 9e 
    240d:	48 8b b4 24 88 00 00 	mov    rsi,QWORD PTR [rsp+0x88]
    2414:	00 
    2415:	c7 84 24 98 01 00 00 	mov    DWORD PTR [rsp+0x198],0x2
    241c:	02 00 00 00 
    2420:	48 01 d8             	add    rax,rbx
    2423:	48 89 c2             	mov    rdx,rax
    2426:	49 89 f4             	mov    r12,rsi
    2429:	48 c1 ea 1e          	shr    rdx,0x1e
    242d:	48 31 c2             	xor    rdx,rax
    2430:	48 0f af d7          	imul   rdx,rdi
    2434:	48 89 d0             	mov    rax,rdx
    2437:	48 c1 e8 1b          	shr    rax,0x1b
    243b:	48 31 d0             	xor    rax,rdx
    243e:	48 ba ab aa aa aa aa 	movabs rdx,0xaaaaaaaaaaaaaaab
    2445:	aa aa aa 
    2448:	49 0f af c3          	imul   rax,r11
    244c:	48 89 c1             	mov    rcx,rax
    244f:	48 c1 e9 1f          	shr    rcx,0x1f
    2453:	48 31 c1             	xor    rcx,rax
    2456:	48 89 c8             	mov    rax,rcx
    2459:	48 f7 e2             	mul    rdx
    245c:	48 89 d0             	mov    rax,rdx
    245f:	48 83 e2 fe          	and    rdx,0xfffffffffffffffe
    2463:	48 d1 e8             	shr    rax,1
    2466:	48 01 c2             	add    rdx,rax
    2469:	48 29 d1             	sub    rcx,rdx
    246c:	48 8d 04 8e          	lea    rax,[rsi+rcx*4]
    2470:	8b 10                	mov    edx,DWORD PTR [rax]
    2472:	89 94 24 98 01 00 00 	mov    DWORD PTR [rsp+0x198],edx
    2479:	c7 00 02 00 00 00    	mov    DWORD PTR [rax],0x2
    247f:	8b 8c 24 94 01 00 00 	mov    ecx,DWORD PTR [rsp+0x194]
    2486:	48 b8 2a f8 94 fe 72 	movabs rax,0x3c6ef372fe94f82a
    248d:	f3 6e 3c 
    2490:	48 01 c3             	add    rbx,rax
    2493:	48 89 da             	mov    rdx,rbx
    2496:	48 89 5c 24 70       	mov    QWORD PTR [rsp+0x70],rbx
    249b:	48 c1 ea 1e          	shr    rdx,0x1e
    249f:	48 31 da             	xor    rdx,rbx
    24a2:	48 8b 9c 24 80 00 00 	mov    rbx,QWORD PTR [rsp+0x80]
    24a9:	00 
    24aa:	48 0f af d7          	imul   rdx,rdi
    24ae:	48 89 d0             	mov    rax,rdx
    24b1:	48 c1 e8 1b          	shr    rax,0x1b
    24b5:	48 31 d0             	xor    rax,rdx
    24b8:	49 0f af c3          	imul   rax,r11
    24bc:	48 89 c2             	mov    rdx,rax
    24bf:	48 c1 ea 1f          	shr    rdx,0x1f
    24c3:	48 31 d0             	xor    rax,rdx
    24c6:	83 e0 01             	and    eax,0x1
    24c9:	48 8d 04 86          	lea    rax,[rsi+rax*4]
    24cd:	8b 10                	mov    edx,DWORD PTR [rax]
    24cf:	89 94 24 94 01 00 00 	mov    DWORD PTR [rsp+0x194],edx
    24d6:	89 08                	mov    DWORD PTR [rax],ecx
    24d8:	49 63 2c 24          	movsxd rbp,DWORD PTR [r12]
    24dc:	44 8b 44 24 08       	mov    r8d,DWORD PTR [rsp+0x8]
    24e1:	4c 89 e9             	mov    rcx,r13
    24e4:	48 89 de             	mov    rsi,rbx
    24e7:	48 8b 94 24 40 01 00 	mov    rdx,QWORD PTR [rsp+0x140]
    24ee:	00 
    24ef:	48 8d 05 aa 27 00 00 	lea    rax,[rip+0x27aa]        # 4ca0 <run_variant>
    24f6:	48 8b bc 24 50 01 00 	mov    rdi,QWORD PTR [rsp+0x150]
    24fd:	00 
    24fe:	4c 8b 0c e8          	mov    r9,QWORD PTR [rax+rbp*8]
    2502:	49 39 d7             	cmp    r15,rdx
    2505:	4c 89 4c 24 18       	mov    QWORD PTR [rsp+0x18],r9
    250a:	49 0f 46 d7          	cmovbe rdx,r15
    250e:	41 ff d1             	call   r9
    2511:	48 8b bc 24 50 01 00 	mov    rdi,QWORD PTR [rsp+0x150]
    2518:	00 
    2519:	0f ae e8             	lfence 
    251c:	0f 01 f9             	rdtscp 
    251f:	89 c0                	mov    eax,eax
    2521:	48 c1 e2 20          	shl    rdx,0x20
    2525:	44 8b 44 24 08       	mov    r8d,DWORD PTR [rsp+0x8]
    252a:	4c 8b 4c 24 18       	mov    r9,QWORD PTR [rsp+0x18]
    252f:	48 09 c2             	or     rdx,rax
    2532:	4c 89 e9             	mov    rcx,r13
    2535:	48 89 de             	mov    rsi,rbx
    2538:	48 89 54 24 10       	mov    QWORD PTR [rsp+0x10],rdx
    253d:	4c 89 fa             	mov    rdx,r15
    2540:	41 ff d1             	call   r9
    2543:	0f ae e8             	lfence 
    2546:	0f 01 f9             	rdtscp 
    2549:	48 c1 e2 20          	shl    rdx,0x20
    254d:	89 c0                	mov    eax,eax
    254f:	48 09 c2             	or     rdx,rax
    2552:	48 2b 54 24 10       	sub    rdx,QWORD PTR [rsp+0x10]
    2557:	0f 88 b3 01 00 00    	js     2710 <main+0x1350>
    255d:	66 0f ef c9          	pxor   xmm1,xmm1
    2561:	f2 48 0f 2a ca       	cvtsi2sd xmm1,rdx
    2566:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
    256b:	4c 89 f7             	mov    rdi,r14
    256e:	48 c1 e5 04          	shl    rbp,0x4
    2572:	49 83 c4 04          	add    r12,0x4
    2576:	f2 0f 5e 4c 24 48    	divsd  xmm1,QWORD PTR [rsp+0x48]
    257c:	48 89 54 24 18       	mov    QWORD PTR [rsp+0x18],rdx
    2581:	f2 0f 11 4c 24 10    	movsd  QWORD PTR [rsp+0x10],xmm1
    2587:	e8 c4 06 00 00       	call   2c50 <csv_write_quoted>
    258c:	4c 89 f6             	mov    rsi,r14
    258f:	bf 2c 00 00 00       	mov    edi,0x2c
    2594:	e8 27 ed ff ff       	call   12c0 <fputc@plt>
    2599:	48 8b 74 24 28       	mov    rsi,QWORD PTR [rsp+0x28]
    259e:	4c 89 f7             	mov    rdi,r14
    25a1:	e8 aa 06 00 00       	call   2c50 <csv_write_quoted>
    25a6:	4c 89 f6             	mov    rsi,r14
    25a9:	bf 2c 00 00 00       	mov    edi,0x2c
    25ae:	e8 0d ed ff ff       	call   12c0 <fputc@plt>
    25b3:	48 8b 74 24 68       	mov    rsi,QWORD PTR [rsp+0x68]
    25b8:	4c 89 f7             	mov    rdi,r14
    25bb:	e8 90 06 00 00       	call   2c50 <csv_write_quoted>
    25c0:	48 83 ec 08          	sub    rsp,0x8
    25c4:	be 01 00 00 00       	mov    esi,0x1
    25c9:	4c 89 f7             	mov    rdi,r14
    25cc:	8b 84 24 a0 00 00 00 	mov    eax,DWORD PTR [rsp+0xa0]
    25d3:	50                   	push   rax
    25d4:	48 8d 05 e5 26 00 00 	lea    rax,[rip+0x26e5]        # 4cc0 <variants>
    25db:	ff 74 24 50          	push   QWORD PTR [rsp+0x50]
    25df:	48 8b 54 24 30       	mov    rdx,QWORD PTR [rsp+0x30]
    25e4:	48 8b 0c 28          	mov    rcx,QWORD PTR [rax+rbp*1]
    25e8:	b8 02 00 00 00       	mov    eax,0x2
    25ed:	52                   	push   rdx
    25ee:	48 8d 15 83 12 00 00 	lea    rdx,[rip+0x1283]        # 3878 <_IO_stdin_used+0x878>
    25f5:	ff 74 24 40          	push   QWORD PTR [rsp+0x40]
    25f9:	ff 74 24 28          	push   QWORD PTR [rsp+0x28]
    25fd:	41 57                	push   r15
    25ff:	41 55                	push   r13
    2601:	f2 0f 10 4c 24 50    	movsd  xmm1,QWORD PTR [rsp+0x50]
    2607:	f2 0f 10 84 24 98 00 	movsd  xmm0,QWORD PTR [rsp+0x98]
    260e:	00 00 
    2610:	4c 8b 4c 24 78       	mov    r9,QWORD PTR [rsp+0x78]
    2615:	4c 8b 84 24 90 00 00 	mov    r8,QWORD PTR [rsp+0x90]
    261c:	00 
    261d:	e8 5e ed ff ff       	call   1380 <__fprintf_chk@plt>
    2622:	48 83 c4 40          	add    rsp,0x40
    2626:	4c 39 64 24 60       	cmp    QWORD PTR [rsp+0x60],r12
    262b:	0f 85 a7 fe ff ff    	jne    24d8 <main+0x1118>
    2631:	48 83 04 24 01       	add    QWORD PTR [rsp],0x1
    2636:	48 8b 04 24          	mov    rax,QWORD PTR [rsp]
    263a:	48 39 44 24 78       	cmp    QWORD PTR [rsp+0x78],rax
    263f:	0f 87 93 fd ff ff    	ja     23d8 <main+0x1018>
    2645:	48 83 44 24 20 01    	add    QWORD PTR [rsp+0x20],0x1
    264b:	48 8b 9c 24 a8 00 00 	mov    rbx,QWORD PTR [rsp+0xa8]
    2652:	00 
    2653:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
    2658:	48 01 9c 24 90 00 00 	add    QWORD PTR [rsp+0x90],rbx
    265f:	00 
    2660:	48 3b 84 24 a0 00 00 	cmp    rax,QWORD PTR [rsp+0xa0]
    2667:	00 
    2668:	0f 82 52 fd ff ff    	jb     23c0 <main+0x1000>
    266e:	48 83 84 24 d8 00 00 	add    QWORD PTR [rsp+0xd8],0x1
    2675:	00 01 
    2677:	48 b8 b9 e5 e4 1c 6d 	movabs rax,0xbf58476d1ce4e5b9
    267e:	47 58 bf 
    2681:	48 8b 9c 24 d8 00 00 	mov    rbx,QWORD PTR [rsp+0xd8]
    2688:	00 
    2689:	48 01 84 24 08 01 00 	add    QWORD PTR [rsp+0x108],rax
    2690:	00 
    2691:	48 3b 9c 24 e0 00 00 	cmp    rbx,QWORD PTR [rsp+0xe0]
    2698:	00 
    2699:	0f 82 d2 fc ff ff    	jb     2371 <main+0xfb1>
    269f:	48 8b 9c 24 f8 00 00 	mov    rbx,QWORD PTR [rsp+0xf8]
    26a6:	00 
    26a7:	4c 8b a4 24 80 00 00 	mov    r12,QWORD PTR [rsp+0x80]
    26ae:	00 
    26af:	31 c0                	xor    eax,eax
    26b1:	4d 89 f5             	mov    r13,r14
    26b4:	48 83 bc 24 e0 00 00 	cmp    QWORD PTR [rsp+0xe0],0x0
    26bb:	00 00 
    26bd:	48 0f 45 84 24 d0 00 	cmovne rax,QWORD PTR [rsp+0xd0]
    26c4:	00 00 
    26c6:	4c 89 e7             	mov    rdi,r12
    26c9:	48 8d 44 03 01       	lea    rax,[rbx+rax*1+0x1]
    26ce:	48 89 84 24 f8 00 00 	mov    QWORD PTR [rsp+0xf8],rax
    26d5:	00 
    26d6:	e8 45 eb ff ff       	call   1220 <free@plt>
    26db:	48 8b bc 24 50 01 00 	mov    rdi,QWORD PTR [rsp+0x150]
    26e2:	00 
    26e3:	e8 38 eb ff ff       	call   1220 <free@plt>
    26e8:	48 8b 9c 24 e8 00 00 	mov    rbx,QWORD PTR [rsp+0xe8]
    26ef:	00 
    26f0:	48 8d 43 01          	lea    rax,[rbx+0x1]
    26f4:	48 3b 9c 24 18 01 00 	cmp    rbx,QWORD PTR [rsp+0x118]
    26fb:	00 
    26fc:	74 51                	je     274f <main+0x138f>
    26fe:	48 89 84 24 e8 00 00 	mov    QWORD PTR [rsp+0xe8],rax
    2705:	00 
    2706:	e9 51 fa ff ff       	jmp    215c <main+0xd9c>
    270b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
    2710:	48 89 d0             	mov    rax,rdx
    2713:	48 89 d1             	mov    rcx,rdx
    2716:	66 0f ef c9          	pxor   xmm1,xmm1
    271a:	48 d1 e8             	shr    rax,1
    271d:	83 e1 01             	and    ecx,0x1
    2720:	48 09 c8             	or     rax,rcx
    2723:	f2 48 0f 2a c8       	cvtsi2sd xmm1,rax
    2728:	f2 0f 58 c9          	addsd  xmm1,xmm1
    272c:	e9 35 fe ff ff       	jmp    2566 <main+0x11a6>
    2731:	48 89 c8             	mov    rax,rcx
    2734:	83 e1 01             	and    ecx,0x1
    2737:	66 0f ef c0          	pxor   xmm0,xmm0
    273b:	48 d1 e8             	shr    rax,1
    273e:	48 09 c8             	or     rax,rcx
    2741:	f2 48 0f 2a c0       	cvtsi2sd xmm0,rax
    2746:	f2 0f 58 c0          	addsd  xmm0,xmm0
    274a:	e9 bd fb ff ff       	jmp    230c <main+0xf4c>
    274f:	48 83 84 24 f0 00 00 	add    QWORD PTR [rsp+0xf0],0x1
    2756:	00 01 
    2758:	4d 87 fd             	xchg   r13,r15
    275b:	48 8b 84 24 f0 00 00 	mov    rax,QWORD PTR [rsp+0xf0]
    2762:	00 
    2763:	48 83 44 24 38 24    	add    QWORD PTR [rsp+0x38],0x24
    2769:	48 3b 84 24 00 01 00 	cmp    rax,QWORD PTR [rsp+0x100]
    2770:	00 
    2771:	0f 82 d0 f9 ff ff    	jb     2147 <main+0xd87>
    2777:	4c 39 3d a2 28 00 00 	cmp    QWORD PTR [rip+0x28a2],r15        # 5020 <stdout@GLIBC_2.2.5>
    277e:	74 08                	je     2788 <main+0x13c8>
    2780:	4c 89 ff             	mov    rdi,r15
    2783:	e8 d8 ea ff ff       	call   1260 <fclose@plt>
    2788:	48 8b bc 24 c8 00 00 	mov    rdi,QWORD PTR [rsp+0xc8]
    278f:	00 
    2790:	e8 8b ea ff ff       	call   1220 <free@plt>
    2795:	48 8b bc 24 b0 00 00 	mov    rdi,QWORD PTR [rsp+0xb0]
    279c:	00 
    279d:	e8 7e ea ff ff       	call   1220 <free@plt>
    27a2:	48 8b bc 24 b8 00 00 	mov    rdi,QWORD PTR [rsp+0xb8]
    27a9:	00 
    27aa:	e8 71 ea ff ff       	call   1220 <free@plt>
    27af:	e9 6e f1 ff ff       	jmp    1922 <main+0x562>
    27b4:	48 8b 3d 85 28 00 00 	mov    rdi,QWORD PTR [rip+0x2885]        # 5040 <stderr@GLIBC_2.2.5>
    27bb:	48 8d 15 86 10 00 00 	lea    rdx,[rip+0x1086]        # 3848 <_IO_stdin_used+0x848>
    27c2:	be 01 00 00 00       	mov    esi,0x1
    27c7:	31 c0                	xor    eax,eax
    27c9:	4d 89 ef             	mov    r15,r13
    27cc:	e8 af eb ff ff       	call   1380 <__fprintf_chk@plt>
    27d1:	48 8b bc 24 50 01 00 	mov    rdi,QWORD PTR [rsp+0x150]
    27d8:	00 
    27d9:	e8 42 ea ff ff       	call   1220 <free@plt>
    27de:	c7 84 24 9c 00 00 00 	mov    DWORD PTR [rsp+0x9c],0x1
    27e5:	01 00 00 00 
    27e9:	eb 8c                	jmp    2777 <main+0x13b7>
    27eb:	48 8b 3d 4e 28 00 00 	mov    rdi,QWORD PTR [rip+0x284e]        # 5040 <stderr@GLIBC_2.2.5>
    27f2:	48 89 d9             	mov    rcx,rbx
    27f5:	31 c0                	xor    eax,eax
    27f7:	4d 89 ef             	mov    r15,r13
    27fa:	48 8d 15 1f 10 00 00 	lea    rdx,[rip+0x101f]        # 3820 <_IO_stdin_used+0x820>
    2801:	be 01 00 00 00       	mov    esi,0x1
    2806:	e8 75 eb ff ff       	call   1380 <__fprintf_chk@plt>
    280b:	c7 84 24 9c 00 00 00 	mov    DWORD PTR [rsp+0x9c],0x1
    2812:	01 00 00 00 
    2816:	e9 5c ff ff ff       	jmp    2777 <main+0x13b7>
    281b:	48 8b 3d 1e 28 00 00 	mov    rdi,QWORD PTR [rip+0x281e]        # 5040 <stderr@GLIBC_2.2.5>
    2822:	4c 89 f1             	mov    rcx,r14
    2825:	31 c0                	xor    eax,eax
    2827:	4d 89 ef             	mov    r15,r13
    282a:	48 8d 15 c7 0f 00 00 	lea    rdx,[rip+0xfc7]        # 37f8 <_IO_stdin_used+0x7f8>
    2831:	be 01 00 00 00       	mov    esi,0x1
    2836:	e8 45 eb ff ff       	call   1380 <__fprintf_chk@plt>
    283b:	c7 84 24 9c 00 00 00 	mov    DWORD PTR [rsp+0x9c],0x2
    2842:	02 00 00 00 
    2846:	e9 2c ff ff ff       	jmp    2777 <main+0x13b7>
    284b:	48 b8 75 6e 6b 6e 6f 	movabs rax,0x6e776f6e6b6e75
    2852:	77 6e 00 
    2855:	48 89 84 24 60 04 00 	mov    QWORD PTR [rsp+0x460],rax
    285c:	00 
    285d:	e9 0c f8 ff ff       	jmp    206e <main+0xcae>
    2862:	48 b8 75 6e 6b 6e 6f 	movabs rax,0x6e776f6e6b6e75
    2869:	77 6e 00 
    286c:	48 89 84 24 40 04 00 	mov    QWORD PTR [rsp+0x440],rax
    2873:	00 
    2874:	e9 b8 f7 ff ff       	jmp    2031 <main+0xc71>
    2879:	48 b8 75 6e 6b 6e 6f 	movabs rax,0x6e776f6e6b6e75
    2880:	77 6e 00 
    2883:	48 89 84 24 20 04 00 	mov    QWORD PTR [rsp+0x420],rax
    288a:	00 
    288b:	e9 80 f7 ff ff       	jmp    2010 <main+0xc50>
    2890:	48 b8 75 6e 6b 6e 6f 	movabs rax,0x6e776f6e6b6e75
    2897:	77 6e 00 
    289a:	48 89 84 24 00 04 00 	mov    QWORD PTR [rsp+0x400],rax
    28a1:	00 
    28a2:	e9 48 f7 ff ff       	jmp    1fef <main+0xc2f>
    28a7:	48 b8 75 6e 6b 6e 6f 	movabs rax,0x6e776f6e6b6e75
    28ae:	77 6e 00 
    28b1:	48 89 84 24 e0 03 00 	mov    QWORD PTR [rsp+0x3e0],rax
    28b8:	00 
    28b9:	e9 10 f7 ff ff       	jmp    1fce <main+0xc0e>
    28be:	48 b8 75 6e 6b 6e 6f 	movabs rax,0x6e776f6e6b6e75
    28c5:	77 6e 00 
    28c8:	48 89 84 24 60 03 00 	mov    QWORD PTR [rsp+0x360],rax
    28cf:	00 
    28d0:	e9 d8 f6 ff ff       	jmp    1fad <main+0xbed>
    28d5:	48 8b 7c 24 08       	mov    rdi,QWORD PTR [rsp+0x8]
    28da:	48 8d 35 6f 08 00 00 	lea    rsi,[rip+0x86f]        # 3150 <_IO_stdin_used+0x150>
    28e1:	e8 6a ea ff ff       	call   1350 <fopen@plt>
    28e6:	49 89 c7             	mov    r15,rax
    28e9:	48 85 c0             	test   rax,rax
    28ec:	0f 85 d3 f7 ff ff    	jne    20c5 <main+0xd05>
    28f2:	48 8b 44 24 18       	mov    rax,QWORD PTR [rsp+0x18]
    28f7:	8b 38                	mov    edi,DWORD PTR [rax]
    28f9:	e8 b2 ea ff ff       	call   13b0 <strerror@plt>
    28fe:	48 8b 4c 24 08       	mov    rcx,QWORD PTR [rsp+0x8]
    2903:	be 01 00 00 00       	mov    esi,0x1
    2908:	48 8b 3d 31 27 00 00 	mov    rdi,QWORD PTR [rip+0x2731]        # 5040 <stderr@GLIBC_2.2.5>
    290f:	49 89 c0             	mov    r8,rax
    2912:	48 8d 15 ff 0d 00 00 	lea    rdx,[rip+0xdff]        # 3718 <_IO_stdin_used+0x718>
    2919:	31 c0                	xor    eax,eax
    291b:	e8 60 ea ff ff       	call   1380 <__fprintf_chk@plt>
    2920:	48 8b bc 24 c8 00 00 	mov    rdi,QWORD PTR [rsp+0xc8]
    2927:	00 
    2928:	e8 f3 e8 ff ff       	call   1220 <free@plt>
    292d:	48 8b bc 24 b0 00 00 	mov    rdi,QWORD PTR [rsp+0xb0]
    2934:	00 
    2935:	e8 e6 e8 ff ff       	call   1220 <free@plt>
    293a:	48 8b bc 24 b8 00 00 	mov    rdi,QWORD PTR [rsp+0xb8]
    2941:	00 
    2942:	e8 d9 e8 ff ff       	call   1220 <free@plt>
    2947:	c7 84 24 9c 00 00 00 	mov    DWORD PTR [rsp+0x9c],0x1
    294e:	01 00 00 00 
    2952:	e9 cb ef ff ff       	jmp    1922 <main+0x562>
    2957:	4c 89 ff             	mov    rdi,r15
    295a:	e8 c1 e8 ff ff       	call   1220 <free@plt>
    295f:	e9 2e f4 ff ff       	jmp    1d92 <main+0x9d2>
    2964:	48 8d 35 87 07 00 00 	lea    rsi,[rip+0x787]        # 30f2 <_IO_stdin_used+0xf2>
    296b:	4c 89 ef             	mov    rdi,r13
    296e:	e8 bd e8 ff ff       	call   1230 <strcasecmp@plt>
    2973:	85 c0                	test   eax,eax
    2975:	0f 84 e9 f2 ff ff    	je     1c64 <main+0x8a4>
    297b:	48 8d 35 b9 07 00 00 	lea    rsi,[rip+0x7b9]        # 313b <_IO_stdin_used+0x13b>
    2982:	4c 89 ef             	mov    rdi,r13
    2985:	e8 a6 e8 ff ff       	call   1230 <strcasecmp@plt>
    298a:	85 c0                	test   eax,eax
    298c:	74 17                	je     29a5 <main+0x15e5>
    298e:	48 8d 35 61 07 00 00 	lea    rsi,[rip+0x761]        # 30f6 <_IO_stdin_used+0xf6>
    2995:	4c 89 ef             	mov    rdi,r13
    2998:	e8 93 e8 ff ff       	call   1230 <strcasecmp@plt>
    299d:	85 c0                	test   eax,eax
    299f:	0f 85 6d f3 ff ff    	jne    1d12 <main+0x952>
    29a5:	b9 00 00 00 40       	mov    ecx,0x40000000
    29aa:	e9 ba f2 ff ff       	jmp    1c69 <main+0x8a9>
    29af:	90                   	nop

00000000000029b0 <_start>:
    29b0:	f3 0f 1e fa          	endbr64 
    29b4:	31 ed                	xor    ebp,ebp
    29b6:	49 89 d1             	mov    r9,rdx
    29b9:	5e                   	pop    rsi
    29ba:	48 89 e2             	mov    rdx,rsp
    29bd:	48 83 e4 f0          	and    rsp,0xfffffffffffffff0
    29c1:	50                   	push   rax
    29c2:	54                   	push   rsp
    29c3:	45 31 c0             	xor    r8d,r8d
    29c6:	31 c9                	xor    ecx,ecx
    29c8:	48 8d 3d f1 e9 ff ff 	lea    rdi,[rip+0xffffffffffffe9f1]        # 13c0 <main>
    29cf:	ff 15 03 26 00 00    	call   QWORD PTR [rip+0x2603]        # 4fd8 <__libc_start_main@GLIBC_2.34>
    29d5:	f4                   	hlt    
    29d6:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    29dd:	00 00 00 

00000000000029e0 <deregister_tm_clones>:
    29e0:	48 8d 3d 29 26 00 00 	lea    rdi,[rip+0x2629]        # 5010 <__TMC_END__>
    29e7:	48 8d 05 22 26 00 00 	lea    rax,[rip+0x2622]        # 5010 <__TMC_END__>
    29ee:	48 39 f8             	cmp    rax,rdi
    29f1:	74 15                	je     2a08 <deregister_tm_clones+0x28>
    29f3:	48 8b 05 e6 25 00 00 	mov    rax,QWORD PTR [rip+0x25e6]        # 4fe0 <_ITM_deregisterTMCloneTable@Base>
    29fa:	48 85 c0             	test   rax,rax
    29fd:	74 09                	je     2a08 <deregister_tm_clones+0x28>
    29ff:	ff e0                	jmp    rax
    2a01:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    2a08:	c3                   	ret    
    2a09:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000002a10 <register_tm_clones>:
    2a10:	48 8d 3d f9 25 00 00 	lea    rdi,[rip+0x25f9]        # 5010 <__TMC_END__>
    2a17:	48 8d 35 f2 25 00 00 	lea    rsi,[rip+0x25f2]        # 5010 <__TMC_END__>
    2a1e:	48 29 fe             	sub    rsi,rdi
    2a21:	48 89 f0             	mov    rax,rsi
    2a24:	48 c1 ee 3f          	shr    rsi,0x3f
    2a28:	48 c1 f8 03          	sar    rax,0x3
    2a2c:	48 01 c6             	add    rsi,rax
    2a2f:	48 d1 fe             	sar    rsi,1
    2a32:	74 14                	je     2a48 <register_tm_clones+0x38>
    2a34:	48 8b 05 b5 25 00 00 	mov    rax,QWORD PTR [rip+0x25b5]        # 4ff0 <_ITM_registerTMCloneTable@Base>
    2a3b:	48 85 c0             	test   rax,rax
    2a3e:	74 08                	je     2a48 <register_tm_clones+0x38>
    2a40:	ff e0                	jmp    rax
    2a42:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    2a48:	c3                   	ret    
    2a49:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000002a50 <__do_global_dtors_aux>:
    2a50:	f3 0f 1e fa          	endbr64 
    2a54:	80 3d ed 25 00 00 00 	cmp    BYTE PTR [rip+0x25ed],0x0        # 5048 <completed.0>
    2a5b:	75 2b                	jne    2a88 <__do_global_dtors_aux+0x38>
    2a5d:	55                   	push   rbp
    2a5e:	48 83 3d 92 25 00 00 	cmp    QWORD PTR [rip+0x2592],0x0        # 4ff8 <__cxa_finalize@GLIBC_2.2.5>
    2a65:	00 
    2a66:	48 89 e5             	mov    rbp,rsp
    2a69:	74 0c                	je     2a77 <__do_global_dtors_aux+0x27>
    2a6b:	48 8b 3d 96 25 00 00 	mov    rdi,QWORD PTR [rip+0x2596]        # 5008 <__dso_handle>
    2a72:	e8 79 e7 ff ff       	call   11f0 <__cxa_finalize@plt>
    2a77:	e8 64 ff ff ff       	call   29e0 <deregister_tm_clones>
    2a7c:	c6 05 c5 25 00 00 01 	mov    BYTE PTR [rip+0x25c5],0x1        # 5048 <completed.0>
    2a83:	5d                   	pop    rbp
    2a84:	c3                   	ret    
    2a85:	0f 1f 00             	nop    DWORD PTR [rax]
    2a88:	c3                   	ret    
    2a89:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000002a90 <frame_dummy>:
    2a90:	f3 0f 1e fa          	endbr64 
    2a94:	e9 77 ff ff ff       	jmp    2a10 <register_tm_clones>
    2a99:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000002aa0 <load_baseline>:
    2aa0:	f3 0f 1e fa          	endbr64 
    2aa4:	48 39 d6             	cmp    rsi,rdx
    2aa7:	72 07                	jb     2ab0 <load_baseline+0x10>
    2aa9:	31 c0                	xor    eax,eax
    2aab:	c3                   	ret    
    2aac:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
    2ab0:	0f b6 04 37          	movzx  eax,BYTE PTR [rdi+rsi*1]
    2ab4:	c3                   	ret    
    2ab5:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
    2abc:	00 00 00 00 

0000000000002ac0 <load_lfence>:
    2ac0:	f3 0f 1e fa          	endbr64 
    2ac4:	48 39 d6             	cmp    rsi,rdx
    2ac7:	72 07                	jb     2ad0 <load_lfence+0x10>
    2ac9:	31 c0                	xor    eax,eax
    2acb:	c3                   	ret    
    2acc:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
    2ad0:	0f ae e8             	lfence 
    2ad3:	0f b6 04 37          	movzx  eax,BYTE PTR [rdi+rsi*1]
    2ad7:	c3                   	ret    
    2ad8:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
    2adf:	00 

0000000000002ae0 <load_mask>:
    2ae0:	f3 0f 1e fa          	endbr64 
    2ae4:	48 39 d6             	cmp    rsi,rdx
    2ae7:	48 19 c0             	sbb    rax,rax
    2aea:	48 21 f0             	and    rax,rsi
    2aed:	0f b6 04 07          	movzx  eax,BYTE PTR [rdi+rax*1]
    2af1:	c3                   	ret    
    2af2:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
    2af9:	00 00 00 00 
    2afd:	0f 1f 00             	nop    DWORD PTR [rax]

0000000000002b00 <run_baseline>:
    2b00:	f3 0f 1e fa          	endbr64 
    2b04:	49 89 c9             	mov    r9,rcx
    2b07:	48 85 d2             	test   rdx,rdx
    2b0a:	74 57                	je     2b63 <run_baseline+0x63>
    2b0c:	48 89 f1             	mov    rcx,rsi
    2b0f:	4c 8d 14 d6          	lea    r10,[rsi+rdx*8]
    2b13:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
    2b18:	48 8b 31             	mov    rsi,QWORD PTR [rcx]
    2b1b:	4c 89 ca             	mov    rdx,r9
    2b1e:	e8 7d ff ff ff       	call   2aa0 <load_baseline>
    2b23:	0f b6 c0             	movzx  eax,al
    2b26:	2d 47 86 c8 61       	sub    eax,0x61c88647
    2b2b:	45 85 c0             	test   r8d,r8d
    2b2e:	74 1b                	je     2b4b <run_baseline+0x4b>
    2b30:	31 d2                	xor    edx,edx
    2b32:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    2b38:	69 c0 0d 66 19 00    	imul   eax,eax,0x19660d
    2b3e:	83 c2 01             	add    edx,0x1
    2b41:	05 5f f3 6e 3c       	add    eax,0x3c6ef35f
    2b46:	41 39 d0             	cmp    r8d,edx
    2b49:	75 ed                	jne    2b38 <run_baseline+0x38>
    2b4b:	0f b6 15 f7 24 00 00 	movzx  edx,BYTE PTR [rip+0x24f7]        # 5049 <e3_sink>
    2b52:	48 83 c1 08          	add    rcx,0x8
    2b56:	31 d0                	xor    eax,edx
    2b58:	88 05 eb 24 00 00    	mov    BYTE PTR [rip+0x24eb],al        # 5049 <e3_sink>
    2b5e:	49 39 ca             	cmp    r10,rcx
    2b61:	75 b5                	jne    2b18 <run_baseline+0x18>
    2b63:	c3                   	ret    
    2b64:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
    2b6b:	00 00 00 00 
    2b6f:	90                   	nop

0000000000002b70 <run_lfence>:
    2b70:	f3 0f 1e fa          	endbr64 
    2b74:	49 89 f2             	mov    r10,rsi
    2b77:	49 89 d1             	mov    r9,rdx
    2b7a:	49 89 cb             	mov    r11,rcx
    2b7d:	48 85 d2             	test   rdx,rdx
    2b80:	74 51                	je     2bd3 <run_lfence+0x63>
    2b82:	31 c9                	xor    ecx,ecx
    2b84:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
    2b88:	49 8b 34 ca          	mov    rsi,QWORD PTR [r10+rcx*8]
    2b8c:	4c 89 da             	mov    rdx,r11
    2b8f:	e8 2c ff ff ff       	call   2ac0 <load_lfence>
    2b94:	0f b6 c0             	movzx  eax,al
    2b97:	2d 47 86 c8 61       	sub    eax,0x61c88647
    2b9c:	45 85 c0             	test   r8d,r8d
    2b9f:	74 1a                	je     2bbb <run_lfence+0x4b>
    2ba1:	31 d2                	xor    edx,edx
    2ba3:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
    2ba8:	69 c0 0d 66 19 00    	imul   eax,eax,0x19660d
    2bae:	83 c2 01             	add    edx,0x1
    2bb1:	05 5f f3 6e 3c       	add    eax,0x3c6ef35f
    2bb6:	41 39 d0             	cmp    r8d,edx
    2bb9:	75 ed                	jne    2ba8 <run_lfence+0x38>
    2bbb:	0f b6 15 87 24 00 00 	movzx  edx,BYTE PTR [rip+0x2487]        # 5049 <e3_sink>
    2bc2:	48 83 c1 01          	add    rcx,0x1
    2bc6:	31 d0                	xor    eax,edx
    2bc8:	88 05 7b 24 00 00    	mov    BYTE PTR [rip+0x247b],al        # 5049 <e3_sink>
    2bce:	49 39 c9             	cmp    r9,rcx
    2bd1:	75 b5                	jne    2b88 <run_lfence+0x18>
    2bd3:	c3                   	ret    
    2bd4:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
    2bdb:	00 00 00 00 
    2bdf:	90                   	nop

0000000000002be0 <run_mask>:
    2be0:	f3 0f 1e fa          	endbr64 
    2be4:	49 89 c9             	mov    r9,rcx
    2be7:	48 85 d2             	test   rdx,rdx
    2bea:	74 57                	je     2c43 <run_mask+0x63>
    2bec:	48 89 f1             	mov    rcx,rsi
    2bef:	4c 8d 14 d6          	lea    r10,[rsi+rdx*8]
    2bf3:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
    2bf8:	48 8b 31             	mov    rsi,QWORD PTR [rcx]
    2bfb:	4c 89 ca             	mov    rdx,r9
    2bfe:	e8 dd fe ff ff       	call   2ae0 <load_mask>
    2c03:	0f b6 c0             	movzx  eax,al
    2c06:	2d 47 86 c8 61       	sub    eax,0x61c88647
    2c0b:	45 85 c0             	test   r8d,r8d
    2c0e:	74 1b                	je     2c2b <run_mask+0x4b>
    2c10:	31 d2                	xor    edx,edx
    2c12:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    2c18:	69 c0 0d 66 19 00    	imul   eax,eax,0x19660d
    2c1e:	83 c2 01             	add    edx,0x1
    2c21:	05 5f f3 6e 3c       	add    eax,0x3c6ef35f
    2c26:	41 39 d0             	cmp    r8d,edx
    2c29:	75 ed                	jne    2c18 <run_mask+0x38>
    2c2b:	0f b6 15 17 24 00 00 	movzx  edx,BYTE PTR [rip+0x2417]        # 5049 <e3_sink>
    2c32:	48 83 c1 08          	add    rcx,0x8
    2c36:	31 d0                	xor    eax,edx
    2c38:	88 05 0b 24 00 00    	mov    BYTE PTR [rip+0x240b],al        # 5049 <e3_sink>
    2c3e:	49 39 ca             	cmp    r10,rcx
    2c41:	75 b5                	jne    2bf8 <run_mask+0x18>
    2c43:	c3                   	ret    
    2c44:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
    2c4b:	00 00 00 00 
    2c4f:	90                   	nop

0000000000002c50 <csv_write_quoted>:
    2c50:	55                   	push   rbp
    2c51:	48 89 fd             	mov    rbp,rdi
    2c54:	53                   	push   rbx
    2c55:	48 89 f3             	mov    rbx,rsi
    2c58:	48 89 fe             	mov    rsi,rdi
    2c5b:	bf 22 00 00 00       	mov    edi,0x22
    2c60:	48 83 ec 08          	sub    rsp,0x8
    2c64:	e8 57 e6 ff ff       	call   12c0 <fputc@plt>
    2c69:	0f b6 03             	movzx  eax,BYTE PTR [rbx]
    2c6c:	84 c0                	test   al,al
    2c6e:	75 19                	jne    2c89 <csv_write_quoted+0x39>
    2c70:	eb 42                	jmp    2cb4 <csv_write_quoted+0x64>
    2c72:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    2c78:	e8 43 e6 ff ff       	call   12c0 <fputc@plt>
    2c7d:	0f b6 43 01          	movzx  eax,BYTE PTR [rbx+0x1]
    2c81:	48 83 c3 01          	add    rbx,0x1
    2c85:	84 c0                	test   al,al
    2c87:	74 2b                	je     2cb4 <csv_write_quoted+0x64>
    2c89:	3c 22                	cmp    al,0x22
    2c8b:	74 43                	je     2cd0 <csv_write_quoted+0x80>
    2c8d:	0f be 3b             	movsx  edi,BYTE PTR [rbx]
    2c90:	48 89 ee             	mov    rsi,rbp
    2c93:	40 80 ff 0a          	cmp    dil,0xa
    2c97:	74 06                	je     2c9f <csv_write_quoted+0x4f>
    2c99:	40 80 ff 0d          	cmp    dil,0xd
    2c9d:	75 d9                	jne    2c78 <csv_write_quoted+0x28>
    2c9f:	bf 20 00 00 00       	mov    edi,0x20
    2ca4:	48 83 c3 01          	add    rbx,0x1
    2ca8:	e8 13 e6 ff ff       	call   12c0 <fputc@plt>
    2cad:	0f b6 03             	movzx  eax,BYTE PTR [rbx]
    2cb0:	84 c0                	test   al,al
    2cb2:	75 d5                	jne    2c89 <csv_write_quoted+0x39>
    2cb4:	48 83 c4 08          	add    rsp,0x8
    2cb8:	48 89 ee             	mov    rsi,rbp
    2cbb:	bf 22 00 00 00       	mov    edi,0x22
    2cc0:	5b                   	pop    rbx
    2cc1:	5d                   	pop    rbp
    2cc2:	e9 f9 e5 ff ff       	jmp    12c0 <fputc@plt>
    2cc7:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
    2cce:	00 00 
    2cd0:	48 89 ee             	mov    rsi,rbp
    2cd3:	bf 22 00 00 00       	mov    edi,0x22
    2cd8:	e8 e3 e5 ff ff       	call   12c0 <fputc@plt>
    2cdd:	eb ae                	jmp    2c8d <csv_write_quoted+0x3d>
    2cdf:	90                   	nop

0000000000002ce0 <parse_ull>:
    2ce0:	41 54                	push   r12
    2ce2:	55                   	push   rbp
    2ce3:	53                   	push   rbx
    2ce4:	48 83 ec 10          	sub    rsp,0x10
    2ce8:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    2cef:	00 00 
    2cf1:	48 89 44 24 08       	mov    QWORD PTR [rsp+0x8],rax
    2cf6:	31 c0                	xor    eax,eax
    2cf8:	48 85 ff             	test   rdi,rdi
    2cfb:	74 6b                	je     2d68 <parse_ull+0x88>
    2cfd:	80 3f 00             	cmp    BYTE PTR [rdi],0x0
    2d00:	48 89 fd             	mov    rbp,rdi
    2d03:	74 63                	je     2d68 <parse_ull+0x88>
    2d05:	49 89 f4             	mov    r12,rsi
    2d08:	e8 33 e5 ff ff       	call   1240 <__errno_location@plt>
    2d0d:	48 89 e6             	mov    rsi,rsp
    2d10:	ba 0a 00 00 00       	mov    edx,0xa
    2d15:	48 89 ef             	mov    rdi,rbp
    2d18:	c7 00 00 00 00 00    	mov    DWORD PTR [rax],0x0
    2d1e:	48 89 c3             	mov    rbx,rax
    2d21:	48 c7 04 24 00 00 00 	mov    QWORD PTR [rsp],0x0
    2d28:	00 
    2d29:	e8 c2 e5 ff ff       	call   12f0 <strtoull@plt>
    2d2e:	44 8b 03             	mov    r8d,DWORD PTR [rbx]
    2d31:	45 85 c0             	test   r8d,r8d
    2d34:	75 32                	jne    2d68 <parse_ull+0x88>
    2d36:	48 8b 14 24          	mov    rdx,QWORD PTR [rsp]
    2d3a:	48 85 d2             	test   rdx,rdx
    2d3d:	74 29                	je     2d68 <parse_ull+0x88>
    2d3f:	80 3a 00             	cmp    BYTE PTR [rdx],0x0
    2d42:	75 24                	jne    2d68 <parse_ull+0x88>
    2d44:	49 89 04 24          	mov    QWORD PTR [r12],rax
    2d48:	48 8b 44 24 08       	mov    rax,QWORD PTR [rsp+0x8]
    2d4d:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
    2d54:	00 00 
    2d56:	75 18                	jne    2d70 <parse_ull+0x90>
    2d58:	48 83 c4 10          	add    rsp,0x10
    2d5c:	44 89 c0             	mov    eax,r8d
    2d5f:	5b                   	pop    rbx
    2d60:	5d                   	pop    rbp
    2d61:	41 5c                	pop    r12
    2d63:	c3                   	ret    
    2d64:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
    2d68:	41 b8 ff ff ff ff    	mov    r8d,0xffffffff
    2d6e:	eb d8                	jmp    2d48 <parse_ull+0x68>
    2d70:	e8 0b e5 ff ff       	call   1280 <__stack_chk_fail@plt>
    2d75:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
    2d7c:	00 00 00 00 

0000000000002d80 <read_cpuinfo_field>:
    2d80:	41 57                	push   r15
    2d82:	41 56                	push   r14
    2d84:	49 89 fe             	mov    r14,rdi
    2d87:	48 8d 3d 78 02 00 00 	lea    rdi,[rip+0x278]        # 3006 <_IO_stdin_used+0x6>
    2d8e:	41 55                	push   r13
    2d90:	49 89 d5             	mov    r13,rdx
    2d93:	41 54                	push   r12
    2d95:	55                   	push   rbp
    2d96:	53                   	push   rbx
    2d97:	48 81 ec 28 02 00 00 	sub    rsp,0x228
    2d9e:	48 89 74 24 08       	mov    QWORD PTR [rsp+0x8],rsi
    2da3:	48 8d 35 5a 02 00 00 	lea    rsi,[rip+0x25a]        # 3004 <_IO_stdin_used+0x4>
    2daa:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    2db1:	00 00 
    2db3:	48 89 84 24 18 02 00 	mov    QWORD PTR [rsp+0x218],rax
    2dba:	00 
    2dbb:	31 c0                	xor    eax,eax
    2dbd:	e8 8e e5 ff ff       	call   1350 <fopen@plt>
    2dc2:	48 85 c0             	test   rax,rax
    2dc5:	0f 84 2f 01 00 00    	je     2efa <read_cpuinfo_field+0x17a>
    2dcb:	4c 89 f7             	mov    rdi,r14
    2dce:	48 89 c5             	mov    rbp,rax
    2dd1:	4c 8d 64 24 10       	lea    r12,[rsp+0x10]
    2dd6:	e8 95 e4 ff ff       	call   1270 <strlen@plt>
    2ddb:	48 89 c3             	mov    rbx,rax
    2dde:	48 89 ea             	mov    rdx,rbp
    2de1:	be 00 02 00 00       	mov    esi,0x200
    2de6:	4c 89 e7             	mov    rdi,r12
    2de9:	e8 f2 e4 ff ff       	call   12e0 <fgets@plt>
    2dee:	48 85 c0             	test   rax,rax
    2df1:	0f 84 f5 00 00 00    	je     2eec <read_cpuinfo_field+0x16c>
    2df7:	48 89 da             	mov    rdx,rbx
    2dfa:	4c 89 f6             	mov    rsi,r14
    2dfd:	4c 89 e7             	mov    rdi,r12
    2e00:	e8 4b e4 ff ff       	call   1250 <strncmp@plt>
    2e05:	41 89 c7             	mov    r15d,eax
    2e08:	85 c0                	test   eax,eax
    2e0a:	75 d2                	jne    2dde <read_cpuinfo_field+0x5e>
    2e0c:	49 8d 04 1c          	lea    rax,[r12+rbx*1]
    2e10:	0f b6 10             	movzx  edx,BYTE PTR [rax]
    2e13:	80 fa 20             	cmp    dl,0x20
    2e16:	75 15                	jne    2e2d <read_cpuinfo_field+0xad>
    2e18:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
    2e1f:	00 
    2e20:	0f b6 50 01          	movzx  edx,BYTE PTR [rax+0x1]
    2e24:	48 83 c0 01          	add    rax,0x1
    2e28:	80 fa 20             	cmp    dl,0x20
    2e2b:	74 f3                	je     2e20 <read_cpuinfo_field+0xa0>
    2e2d:	80 fa 09             	cmp    dl,0x9
    2e30:	74 ee                	je     2e20 <read_cpuinfo_field+0xa0>
    2e32:	80 fa 3a             	cmp    dl,0x3a
    2e35:	75 a7                	jne    2dde <read_cpuinfo_field+0x5e>
    2e37:	4c 8d 70 01          	lea    r14,[rax+0x1]
    2e3b:	0f b6 40 01          	movzx  eax,BYTE PTR [rax+0x1]
    2e3f:	3c 09                	cmp    al,0x9
    2e41:	74 0d                	je     2e50 <read_cpuinfo_field+0xd0>
    2e43:	3c 20                	cmp    al,0x20
    2e45:	75 1a                	jne    2e61 <read_cpuinfo_field+0xe1>
    2e47:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
    2e4e:	00 00 
    2e50:	41 0f b6 46 01       	movzx  eax,BYTE PTR [r14+0x1]
    2e55:	49 83 c6 01          	add    r14,0x1
    2e59:	3c 20                	cmp    al,0x20
    2e5b:	74 f3                	je     2e50 <read_cpuinfo_field+0xd0>
    2e5d:	3c 09                	cmp    al,0x9
    2e5f:	74 ef                	je     2e50 <read_cpuinfo_field+0xd0>
    2e61:	4c 89 f7             	mov    rdi,r14
    2e64:	e8 07 e4 ff ff       	call   1270 <strlen@plt>
    2e69:	4c 01 f0             	add    rax,r14
    2e6c:	4c 39 f0             	cmp    rax,r14
    2e6f:	76 18                	jbe    2e89 <read_cpuinfo_field+0x109>
    2e71:	48 b9 ff d9 ff ff fe 	movabs rcx,0xfffffffeffffd9ff
    2e78:	ff ff ff 
    2e7b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
    2e80:	0f b6 50 ff          	movzx  edx,BYTE PTR [rax-0x1]
    2e84:	80 fa 20             	cmp    dl,0x20
    2e87:	76 4f                	jbe    2ed8 <read_cpuinfo_field+0x158>
    2e89:	48 8b 7c 24 08       	mov    rdi,QWORD PTR [rsp+0x8]
    2e8e:	4c 89 f1             	mov    rcx,r14
    2e91:	4c 89 ee             	mov    rsi,r13
    2e94:	31 c0                	xor    eax,eax
    2e96:	48 8d 15 77 01 00 00 	lea    rdx,[rip+0x177]        # 3014 <_IO_stdin_used+0x14>
    2e9d:	e8 ee e3 ff ff       	call   1290 <snprintf@plt>
    2ea2:	48 89 ef             	mov    rdi,rbp
    2ea5:	e8 b6 e3 ff ff       	call   1260 <fclose@plt>
    2eaa:	48 8b 84 24 18 02 00 	mov    rax,QWORD PTR [rsp+0x218]
    2eb1:	00 
    2eb2:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
    2eb9:	00 00 
    2ebb:	75 43                	jne    2f00 <read_cpuinfo_field+0x180>
    2ebd:	48 81 c4 28 02 00 00 	add    rsp,0x228
    2ec4:	44 89 f8             	mov    eax,r15d
    2ec7:	5b                   	pop    rbx
    2ec8:	5d                   	pop    rbp
    2ec9:	41 5c                	pop    r12
    2ecb:	41 5d                	pop    r13
    2ecd:	41 5e                	pop    r14
    2ecf:	41 5f                	pop    r15
    2ed1:	c3                   	ret    
    2ed2:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    2ed8:	48 0f a3 d1          	bt     rcx,rdx
    2edc:	72 ab                	jb     2e89 <read_cpuinfo_field+0x109>
    2ede:	48 83 e8 01          	sub    rax,0x1
    2ee2:	c6 00 00             	mov    BYTE PTR [rax],0x0
    2ee5:	4c 39 f0             	cmp    rax,r14
    2ee8:	75 96                	jne    2e80 <read_cpuinfo_field+0x100>
    2eea:	eb 9d                	jmp    2e89 <read_cpuinfo_field+0x109>
    2eec:	48 89 ef             	mov    rdi,rbp
    2eef:	41 83 cf ff          	or     r15d,0xffffffff
    2ef3:	e8 68 e3 ff ff       	call   1260 <fclose@plt>
    2ef8:	eb b0                	jmp    2eaa <read_cpuinfo_field+0x12a>
    2efa:	41 83 cf ff          	or     r15d,0xffffffff
    2efe:	eb aa                	jmp    2eaa <read_cpuinfo_field+0x12a>
    2f00:	e8 7b e3 ff ff       	call   1280 <__stack_chk_fail@plt>
    2f05:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
    2f0c:	00 00 00 00 

0000000000002f10 <usage>:
    2f10:	48 83 ec 08          	sub    rsp,0x8
    2f14:	48 89 f9             	mov    rcx,rdi
    2f17:	48 8d 05 0c 01 00 00 	lea    rax,[rip+0x10c]        # 302a <_IO_stdin_used+0x2a>
    2f1e:	48 8b 3d 1b 21 00 00 	mov    rdi,QWORD PTR [rip+0x211b]        # 5040 <stderr@GLIBC_2.2.5>
    2f25:	68 00 01 00 00       	push   0x100
    2f2a:	4c 8d 0d 37 02 00 00 	lea    r9,[rip+0x237]        # 3168 <_IO_stdin_used+0x168>
    2f31:	4c 8d 05 df 00 00 00 	lea    r8,[rip+0xdf]        # 3017 <_IO_stdin_used+0x17>
    2f38:	be 01 00 00 00       	mov    esi,0x1
    2f3d:	68 04 29 35 01       	push   0x1352904
    2f42:	48 8d 15 47 02 00 00 	lea    rdx,[rip+0x247]        # 3190 <_IO_stdin_used+0x190>
    2f49:	6a 03                	push   0x3
    2f4b:	6a 05                	push   0x5
    2f4d:	68 40 0d 03 00       	push   0x30d40
    2f52:	50                   	push   rax
    2f53:	31 c0                	xor    eax,eax
    2f55:	e8 26 e4 ff ff       	call   1380 <__fprintf_chk@plt>
    2f5a:	48 83 c4 38          	add    rsp,0x38
    2f5e:	c3                   	ret    

Disassembly of section .fini:

0000000000002f60 <_fini>:
    2f60:	f3 0f 1e fa          	endbr64 
    2f64:	48 83 ec 08          	sub    rsp,0x8
    2f68:	48 83 c4 08          	add    rsp,0x8
    2f6c:	c3                   	ret    
