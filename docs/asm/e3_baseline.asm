
bin/e3_baseline:     file format elf64-x86-64


Disassembly of section .init:

0000000000001000 <_init>:
    1000:	f3 0f 1e fa          	endbr64
    1004:	48 83 ec 08          	sub    rsp,0x8
    1008:	48 8b 05 d9 2f 00 00 	mov    rax,QWORD PTR [rip+0x2fd9]        # 3fe8 <__gmon_start__@Base>
    100f:	48 85 c0             	test   rax,rax
    1012:	74 02                	je     1016 <_init+0x16>
    1014:	ff d0                	call   rax
    1016:	48 83 c4 08          	add    rsp,0x8
    101a:	c3                   	ret

Disassembly of section .plt:

0000000000001020 <.plt>:
    1020:	ff 35 1a 2f 00 00    	push   QWORD PTR [rip+0x2f1a]        # 3f40 <_GLOBAL_OFFSET_TABLE_+0x8>
    1026:	f2 ff 25 1b 2f 00 00 	bnd jmp QWORD PTR [rip+0x2f1b]        # 3f48 <_GLOBAL_OFFSET_TABLE_+0x10>
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

Disassembly of section .plt.got:

0000000000001140 <__cxa_finalize@plt>:
    1140:	f3 0f 1e fa          	endbr64
    1144:	f2 ff 25 ad 2e 00 00 	bnd jmp QWORD PTR [rip+0x2ead]        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    114b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

Disassembly of section .plt.sec:

0000000000001150 <getenv@plt>:
    1150:	f3 0f 1e fa          	endbr64
    1154:	f2 ff 25 f5 2d 00 00 	bnd jmp QWORD PTR [rip+0x2df5]        # 3f50 <getenv@GLIBC_2.2.5>
    115b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001160 <__errno_location@plt>:
    1160:	f3 0f 1e fa          	endbr64
    1164:	f2 ff 25 ed 2d 00 00 	bnd jmp QWORD PTR [rip+0x2ded]        # 3f58 <__errno_location@GLIBC_2.2.5>
    116b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001170 <strncmp@plt>:
    1170:	f3 0f 1e fa          	endbr64
    1174:	f2 ff 25 e5 2d 00 00 	bnd jmp QWORD PTR [rip+0x2de5]        # 3f60 <strncmp@GLIBC_2.2.5>
    117b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001180 <fclose@plt>:
    1180:	f3 0f 1e fa          	endbr64
    1184:	f2 ff 25 dd 2d 00 00 	bnd jmp QWORD PTR [rip+0x2ddd]        # 3f68 <fclose@GLIBC_2.2.5>
    118b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001190 <strlen@plt>:
    1190:	f3 0f 1e fa          	endbr64
    1194:	f2 ff 25 d5 2d 00 00 	bnd jmp QWORD PTR [rip+0x2dd5]        # 3f70 <strlen@GLIBC_2.2.5>
    119b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000011a0 <__stack_chk_fail@plt>:
    11a0:	f3 0f 1e fa          	endbr64
    11a4:	f2 ff 25 cd 2d 00 00 	bnd jmp QWORD PTR [rip+0x2dcd]        # 3f78 <__stack_chk_fail@GLIBC_2.4>
    11ab:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000011b0 <snprintf@plt>:
    11b0:	f3 0f 1e fa          	endbr64
    11b4:	f2 ff 25 c5 2d 00 00 	bnd jmp QWORD PTR [rip+0x2dc5]        # 3f80 <snprintf@GLIBC_2.2.5>
    11bb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000011c0 <uname@plt>:
    11c0:	f3 0f 1e fa          	endbr64
    11c4:	f2 ff 25 bd 2d 00 00 	bnd jmp QWORD PTR [rip+0x2dbd]        # 3f88 <uname@GLIBC_2.2.5>
    11cb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000011d0 <memset@plt>:
    11d0:	f3 0f 1e fa          	endbr64
    11d4:	f2 ff 25 b5 2d 00 00 	bnd jmp QWORD PTR [rip+0x2db5]        # 3f90 <memset@GLIBC_2.2.5>
    11db:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000011e0 <fputc@plt>:
    11e0:	f3 0f 1e fa          	endbr64
    11e4:	f2 ff 25 ad 2d 00 00 	bnd jmp QWORD PTR [rip+0x2dad]        # 3f98 <fputc@GLIBC_2.2.5>
    11eb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000011f0 <fgets@plt>:
    11f0:	f3 0f 1e fa          	endbr64
    11f4:	f2 ff 25 a5 2d 00 00 	bnd jmp QWORD PTR [rip+0x2da5]        # 3fa0 <fgets@GLIBC_2.2.5>
    11fb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001200 <strtoull@plt>:
    1200:	f3 0f 1e fa          	endbr64
    1204:	f2 ff 25 9d 2d 00 00 	bnd jmp QWORD PTR [rip+0x2d9d]        # 3fa8 <strtoull@GLIBC_2.2.5>
    120b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001210 <strcmp@plt>:
    1210:	f3 0f 1e fa          	endbr64
    1214:	f2 ff 25 95 2d 00 00 	bnd jmp QWORD PTR [rip+0x2d95]        # 3fb0 <strcmp@GLIBC_2.2.5>
    121b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001220 <fopen@plt>:
    1220:	f3 0f 1e fa          	endbr64
    1224:	f2 ff 25 8d 2d 00 00 	bnd jmp QWORD PTR [rip+0x2d8d]        # 3fb8 <fopen@GLIBC_2.2.5>
    122b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001230 <fwrite@plt>:
    1230:	f3 0f 1e fa          	endbr64
    1234:	f2 ff 25 85 2d 00 00 	bnd jmp QWORD PTR [rip+0x2d85]        # 3fc0 <fwrite@GLIBC_2.2.5>
    123b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001240 <__fprintf_chk@plt>:
    1240:	f3 0f 1e fa          	endbr64
    1244:	f2 ff 25 7d 2d 00 00 	bnd jmp QWORD PTR [rip+0x2d7d]        # 3fc8 <__fprintf_chk@GLIBC_2.3.4>
    124b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001250 <strerror@plt>:
    1250:	f3 0f 1e fa          	endbr64
    1254:	f2 ff 25 75 2d 00 00 	bnd jmp QWORD PTR [rip+0x2d75]        # 3fd0 <strerror@GLIBC_2.2.5>
    125b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

Disassembly of section .text:

0000000000001260 <main>:
    1260:	f3 0f 1e fa          	endbr64
    1264:	41 57                	push   r15
    1266:	41 56                	push   r14
    1268:	41 55                	push   r13
    126a:	41 54                	push   r12
    126c:	55                   	push   rbp
    126d:	53                   	push   rbx
    126e:	48 81 ec 88 04 00 00 	sub    rsp,0x488
    1275:	48 89 74 24 08       	mov    QWORD PTR [rsp+0x8],rsi
    127a:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    1281:	00 00
    1283:	48 89 84 24 78 04 00 	mov    QWORD PTR [rsp+0x478],rax
    128a:	00
    128b:	31 c0                	xor    eax,eax
    128d:	48 c7 44 24 50 80 96 	mov    QWORD PTR [rsp+0x50],0x989680
    1294:	98 00
    1296:	48 c7 44 24 58 1e 00 	mov    QWORD PTR [rsp+0x58],0x1e
    129d:	00 00
    129f:	83 ff 01             	cmp    edi,0x1
    12a2:	0f 8e b1 07 00 00    	jle    1a59 <main+0x7f9>
    12a8:	8d 47 fe             	lea    eax,[rdi-0x2]
    12ab:	41 89 fc             	mov    r12d,edi
    12ae:	48 8d 6e 08          	lea    rbp,[rsi+0x8]
    12b2:	bb 02 00 00 00       	mov    ebx,0x2
    12b7:	83 e0 fe             	and    eax,0xfffffffe
    12ba:	4c 8d 2d 5e 0d 00 00 	lea    r13,[rip+0xd5e]        # 201f <_IO_stdin_used+0x1f>
    12c1:	48 c7 44 24 18 00 00 	mov    QWORD PTR [rsp+0x18],0x0
    12c8:	00 00
    12ca:	4c 8d 35 55 0d 00 00 	lea    r14,[rip+0xd55]        # 2026 <_IO_stdin_used+0x26>
    12d1:	48 c7 44 24 20 00 00 	mov    QWORD PTR [rsp+0x20],0x0
    12d8:	00 00
    12da:	83 c0 04             	add    eax,0x4
    12dd:	89 44 24 10          	mov    DWORD PTR [rsp+0x10],eax
    12e1:	eb 2c                	jmp    130f <main+0xaf>
    12e3:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
    12e8:	44 39 e3             	cmp    ebx,r12d
    12eb:	7d 48                	jge    1335 <main+0xd5>
    12ed:	48 8b 54 24 08       	mov    rdx,QWORD PTR [rsp+0x8]
    12f2:	48 63 c3             	movsxd rax,ebx
    12f5:	48 8b 04 c2          	mov    rax,QWORD PTR [rdx+rax*8]
    12f9:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
    12fe:	48 83 c5 10          	add    rbp,0x10
    1302:	83 c3 02             	add    ebx,0x2
    1305:	39 5c 24 10          	cmp    DWORD PTR [rsp+0x10],ebx
    1309:	0f 84 63 01 00 00    	je     1472 <main+0x212>
    130f:	4c 8b 7d 00          	mov    r15,QWORD PTR [rbp+0x0]
    1313:	4c 89 ee             	mov    rsi,r13
    1316:	4c 89 ff             	mov    rdi,r15
    1319:	e8 f2 fe ff ff       	call   1210 <strcmp@plt>
    131e:	85 c0                	test   eax,eax
    1320:	0f 84 ad 05 00 00    	je     18d3 <main+0x673>
    1326:	4c 89 f6             	mov    rsi,r14
    1329:	4c 89 ff             	mov    rdi,r15
    132c:	e8 df fe ff ff       	call   1210 <strcmp@plt>
    1331:	85 c0                	test   eax,eax
    1333:	74 b3                	je     12e8 <main+0x88>
    1335:	48 8d 35 f7 0c 00 00 	lea    rsi,[rip+0xcf7]        # 2033 <_IO_stdin_used+0x33>
    133c:	4c 89 ff             	mov    rdi,r15
    133f:	e8 cc fe ff ff       	call   1210 <strcmp@plt>
    1344:	85 c0                	test   eax,eax
    1346:	0f 85 94 00 00 00    	jne    13e0 <main+0x180>
    134c:	44 39 e3             	cmp    ebx,r12d
    134f:	0f 8c 3b 05 00 00    	jl     1890 <main+0x630>
    1355:	48 8d 35 e4 0c 00 00 	lea    rsi,[rip+0xce4]        # 2040 <_IO_stdin_used+0x40>
    135c:	4c 89 ff             	mov    rdi,r15
    135f:	e8 ac fe ff ff       	call   1210 <strcmp@plt>
    1364:	85 c0                	test   eax,eax
    1366:	0f 85 c4 00 00 00    	jne    1430 <main+0x1d0>
    136c:	48 8b 3d ed 2c 00 00 	mov    rdi,QWORD PTR [rip+0x2ced]        # 4060 <stderr@GLIBC_2.2.5>
    1373:	4c 89 f9             	mov    rcx,r15
    1376:	be 01 00 00 00       	mov    esi,0x1
    137b:	31 c0                	xor    eax,eax
    137d:	48 8d 15 b4 0e 00 00 	lea    rdx,[rip+0xeb4]        # 2238 <_IO_stdin_used+0x238>
    1384:	e8 b7 fe ff ff       	call   1240 <__fprintf_chk@plt>
    1389:	48 8b 44 24 08       	mov    rax,QWORD PTR [rsp+0x8]
    138e:	be 01 00 00 00       	mov    esi,0x1
    1393:	48 8b 3d c6 2c 00 00 	mov    rdi,QWORD PTR [rip+0x2cc6]        # 4060 <stderr@GLIBC_2.2.5>
    139a:	48 8d 15 17 0d 00 00 	lea    rdx,[rip+0xd17]        # 20b8 <_IO_stdin_used+0xb8>
    13a1:	48 8b 08             	mov    rcx,QWORD PTR [rax]
    13a4:	31 c0                	xor    eax,eax
    13a6:	e8 95 fe ff ff       	call   1240 <__fprintf_chk@plt>
    13ab:	41 b8 02 00 00 00    	mov    r8d,0x2
    13b1:	48 8b 84 24 78 04 00 	mov    rax,QWORD PTR [rsp+0x478]
    13b8:	00
    13b9:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
    13c0:	00 00
    13c2:	0f 85 a6 06 00 00    	jne    1a6e <main+0x80e>
    13c8:	48 81 c4 88 04 00 00 	add    rsp,0x488
    13cf:	44 89 c0             	mov    eax,r8d
    13d2:	5b                   	pop    rbx
    13d3:	5d                   	pop    rbp
    13d4:	41 5c                	pop    r12
    13d6:	41 5d                	pop    r13
    13d8:	41 5e                	pop    r14
    13da:	41 5f                	pop    r15
    13dc:	c3                   	ret
    13dd:	0f 1f 00             	nop    DWORD PTR [rax]
    13e0:	48 8d 35 59 0c 00 00 	lea    rsi,[rip+0xc59]        # 2040 <_IO_stdin_used+0x40>
    13e7:	4c 89 ff             	mov    rdi,r15
    13ea:	e8 21 fe ff ff       	call   1210 <strcmp@plt>
    13ef:	85 c0                	test   eax,eax
    13f1:	75 3d                	jne    1430 <main+0x1d0>
    13f3:	44 39 e3             	cmp    ebx,r12d
    13f6:	0f 8d 70 ff ff ff    	jge    136c <main+0x10c>
    13fc:	48 8b 54 24 08       	mov    rdx,QWORD PTR [rsp+0x8]
    1401:	48 63 c3             	movsxd rax,ebx
    1404:	48 8d 74 24 58       	lea    rsi,[rsp+0x58]
    1409:	48 8b 3c c2          	mov    rdi,QWORD PTR [rdx+rax*8]
    140d:	e8 8e 07 00 00       	call   1ba0 <parse_ull>
    1412:	85 c0                	test   eax,eax
    1414:	0f 84 e4 fe ff ff    	je     12fe <main+0x9e>
    141a:	48 8d 15 ef 0d 00 00 	lea    rdx,[rip+0xdef]        # 2210 <_IO_stdin_used+0x210>
    1421:	e9 8f 04 00 00       	jmp    18b5 <main+0x655>
    1426:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    142d:	00 00 00
    1430:	48 8d 35 10 0c 00 00 	lea    rsi,[rip+0xc10]        # 2047 <_IO_stdin_used+0x47>
    1437:	4c 89 ff             	mov    rdi,r15
    143a:	e8 d1 fd ff ff       	call   1210 <strcmp@plt>
    143f:	85 c0                	test   eax,eax
    1441:	0f 85 25 ff ff ff    	jne    136c <main+0x10c>
    1447:	44 39 e3             	cmp    ebx,r12d
    144a:	0f 8d 1c ff ff ff    	jge    136c <main+0x10c>
    1450:	48 8b 54 24 08       	mov    rdx,QWORD PTR [rsp+0x8]
    1455:	48 63 c3             	movsxd rax,ebx
    1458:	48 83 c5 10          	add    rbp,0x10
    145c:	83 c3 02             	add    ebx,0x2
    145f:	48 8b 04 c2          	mov    rax,QWORD PTR [rdx+rax*8]
    1463:	48 89 44 24 18       	mov    QWORD PTR [rsp+0x18],rax
    1468:	39 5c 24 10          	cmp    DWORD PTR [rsp+0x10],ebx
    146c:	0f 85 9d fe ff ff    	jne    130f <main+0xaf>
    1472:	48 83 7c 24 50 00    	cmp    QWORD PTR [rsp+0x50],0x0
    1478:	0f 84 c3 05 00 00    	je     1a41 <main+0x7e1>
    147e:	48 8b 44 24 58       	mov    rax,QWORD PTR [rsp+0x58]
    1483:	48 83 e8 01          	sub    rax,0x1
    1487:	48 3d fe ff ff 7f    	cmp    rax,0x7ffffffe
    148d:	0f 87 ba 05 00 00    	ja     1a4d <main+0x7ed>
    1493:	48 8b 7c 24 18       	mov    rdi,QWORD PTR [rsp+0x18]
    1498:	48 8b 2d a1 2b 00 00 	mov    rbp,QWORD PTR [rip+0x2ba1]        # 4040 <stdout@GLIBC_2.2.5>
    149f:	48 85 ff             	test   rdi,rdi
    14a2:	74 14                	je     14b8 <main+0x258>
    14a4:	48 8d 35 a2 0b 00 00 	lea    rsi,[rip+0xba2]        # 204d <_IO_stdin_used+0x4d>
    14ab:	e8 60 fd ff ff       	call   1210 <strcmp@plt>
    14b0:	85 c0                	test   eax,eax
    14b2:	0f 85 e3 04 00 00    	jne    199b <main+0x73b>
    14b8:	4c 8d ac 24 f0 01 00 	lea    r13,[rsp+0x1f0]
    14bf:	00
    14c0:	31 c0                	xor    eax,eax
    14c2:	b9 50 00 00 00       	mov    ecx,0x50
    14c7:	4c 89 ef             	mov    rdi,r13
    14ca:	f3 48 ab             	rep stos QWORD PTR es:[rdi],rax
    14cd:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
    14d2:	48 85 c0             	test   rax,rax
    14d5:	74 05                	je     14dc <main+0x27c>
    14d7:	80 38 00             	cmp    BYTE PTR [rax],0x0
    14da:	75 27                	jne    1503 <main+0x2a3>
    14dc:	48 8d 3d 6e 0b 00 00 	lea    rdi,[rip+0xb6e]        # 2051 <_IO_stdin_used+0x51>
    14e3:	e8 68 fc ff ff       	call   1150 <getenv@plt>
    14e8:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
    14ed:	48 85 c0             	test   rax,rax
    14f0:	74 05                	je     14f7 <main+0x297>
    14f2:	80 38 00             	cmp    BYTE PTR [rax],0x0
    14f5:	75 0c                	jne    1503 <main+0x2a3>
    14f7:	48 8d 05 19 0b 00 00 	lea    rax,[rip+0xb19]        # 2017 <_IO_stdin_used+0x17>
    14fe:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
    1503:	48 8b 4c 24 20       	mov    rcx,QWORD PTR [rsp+0x20]
    1508:	be 40 00 00 00       	mov    esi,0x40
    150d:	4c 89 ef             	mov    rdi,r13
    1510:	31 c0                	xor    eax,eax
    1512:	4c 8d 25 fb 0a 00 00 	lea    r12,[rip+0xafb]        # 2014 <_IO_stdin_used+0x14>
    1519:	4c 89 e2             	mov    rdx,r12
    151c:	e8 8f fc ff ff       	call   11b0 <snprintf@plt>
    1521:	48 8d 84 24 30 02 00 	lea    rax,[rsp+0x230]
    1528:	00
    1529:	ba 80 00 00 00       	mov    edx,0x80
    152e:	48 8d 3d 27 0b 00 00 	lea    rdi,[rip+0xb27]        # 205c <_IO_stdin_used+0x5c>
    1535:	48 89 c6             	mov    rsi,rax
    1538:	48 89 44 24 38       	mov    QWORD PTR [rsp+0x38],rax
    153d:	e8 fe 06 00 00       	call   1c40 <read_cpuinfo_field>
    1542:	85 c0                	test   eax,eax
    1544:	0f 85 23 04 00 00    	jne    196d <main+0x70d>
    154a:	48 8d 84 24 b0 02 00 	lea    rax,[rsp+0x2b0]
    1551:	00
    1552:	ba 20 00 00 00       	mov    edx,0x20
    1557:	48 8d 3d 09 0b 00 00 	lea    rdi,[rip+0xb09]        # 2067 <_IO_stdin_used+0x67>
    155e:	48 89 c6             	mov    rsi,rax
    1561:	48 89 44 24 28       	mov    QWORD PTR [rsp+0x28],rax
    1566:	e8 d5 06 00 00       	call   1c40 <read_cpuinfo_field>
    156b:	85 c0                	test   eax,eax
    156d:	0f 85 e3 03 00 00    	jne    1956 <main+0x6f6>
    1573:	48 8d 84 24 d0 02 00 	lea    rax,[rsp+0x2d0]
    157a:	00
    157b:	ba 20 00 00 00       	mov    edx,0x20
    1580:	48 8d 3d eb 0a 00 00 	lea    rdi,[rip+0xaeb]        # 2072 <_IO_stdin_used+0x72>
    1587:	48 89 c6             	mov    rsi,rax
    158a:	48 89 44 24 30       	mov    QWORD PTR [rsp+0x30],rax
    158f:	e8 ac 06 00 00       	call   1c40 <read_cpuinfo_field>
    1594:	85 c0                	test   eax,eax
    1596:	0f 85 a3 03 00 00    	jne    193f <main+0x6df>
    159c:	48 8d 84 24 f0 02 00 	lea    rax,[rsp+0x2f0]
    15a3:	00
    15a4:	ba 20 00 00 00       	mov    edx,0x20
    15a9:	48 8d 3d c8 0a 00 00 	lea    rdi,[rip+0xac8]        # 2078 <_IO_stdin_used+0x78>
    15b0:	48 89 c6             	mov    rsi,rax
    15b3:	48 89 44 24 40       	mov    QWORD PTR [rsp+0x40],rax
    15b8:	e8 83 06 00 00       	call   1c40 <read_cpuinfo_field>
    15bd:	85 c0                	test   eax,eax
    15bf:	0f 85 63 03 00 00    	jne    1928 <main+0x6c8>
    15c5:	48 8d 84 24 10 03 00 	lea    rax,[rsp+0x310]
    15cc:	00
    15cd:	ba 20 00 00 00       	mov    edx,0x20
    15d2:	48 8d 3d a8 0a 00 00 	lea    rdi,[rip+0xaa8]        # 2081 <_IO_stdin_used+0x81>
    15d9:	48 89 c6             	mov    rsi,rax
    15dc:	48 89 44 24 48       	mov    QWORD PTR [rsp+0x48],rax
    15e1:	e8 5a 06 00 00       	call   1c40 <read_cpuinfo_field>
    15e6:	85 c0                	test   eax,eax
    15e8:	0f 85 96 03 00 00    	jne    1984 <main+0x724>
    15ee:	48 8d 7c 24 60       	lea    rdi,[rsp+0x60]
    15f3:	e8 c8 fb ff ff       	call   11c0 <uname@plt>
    15f8:	85 c0                	test   eax,eax
    15fa:	0f 84 03 03 00 00    	je     1903 <main+0x6a3>
    1600:	48 b8 75 6e 6b 6e 6f 	movabs rax,0x6e776f6e6b6e75
    1607:	77 6e 00
    160a:	48 89 84 24 30 03 00 	mov    QWORD PTR [rsp+0x330],rax
    1611:	00
    1612:	4c 8d b4 24 b0 03 00 	lea    r14,[rsp+0x3b0]
    1619:	00
    161a:	b9 07 00 00 00       	mov    ecx,0x7
    161f:	48 8d 35 65 0a 00 00 	lea    rsi,[rip+0xa65]        # 208b <_IO_stdin_used+0x8b>
    1626:	ba 00 00 02 00       	mov    edx,0x20000
    162b:	4c 89 f7             	mov    rdi,r14
    162e:	48 8d 1d 8b 0d 00 00 	lea    rbx,[rip+0xd8b]        # 23c0 <indices.0>
    1635:	f3 a4                	rep movs BYTE PTR es:[rdi],BYTE PTR ds:[rsi]
    1637:	48 8d bc 24 f0 03 00 	lea    rdi,[rsp+0x3f0]
    163e:	00
    163f:	48 8d 35 a2 0c 00 00 	lea    rsi,[rip+0xca2]        # 22e8 <_IO_stdin_used+0x2e8>
    1646:	b9 16 00 00 00       	mov    ecx,0x16
    164b:	48 89 7c 24 20       	mov    QWORD PTR [rsp+0x20],rdi
    1650:	f3 a5                	rep movs DWORD PTR es:[rdi],DWORD PTR ds:[rsi]
    1652:	be 01 00 00 00       	mov    esi,0x1
    1657:	48 8d 3d 62 2a 00 00 	lea    rdi,[rip+0x2a62]        # 40c0 <array2>
    165e:	e8 6d fb ff ff       	call   11d0 <memset@plt>
    1663:	31 c9                	xor    ecx,ecx
    1665:	0f 1f 00             	nop    DWORD PTR [rax]
    1668:	89 c8                	mov    eax,ecx
    166a:	83 c1 01             	add    ecx,0x1
    166d:	83 e0 0f             	and    eax,0xf
    1670:	48 8b 3c c3          	mov    rdi,QWORD PTR [rbx+rax*8]
    1674:	e8 f7 04 00 00       	call   1b70 <victim_function>
    1679:	81 f9 e8 03 00 00    	cmp    ecx,0x3e8
    167f:	75 e7                	jne    1668 <main+0x408>
    1681:	0f ae e8             	lfence
    1684:	ba 79 00 00 00       	mov    edx,0x79
    1689:	48 89 e9             	mov    rcx,rbp
    168c:	be 01 00 00 00       	mov    esi,0x1
    1691:	48 8d 3d a8 0c 00 00 	lea    rdi,[rip+0xca8]        # 2340 <_IO_stdin_used+0x340>
    1698:	e8 93 fb ff ff       	call   1230 <fwrite@plt>
    169d:	83 7c 24 58 00       	cmp    DWORD PTR [rsp+0x58],0x0
    16a2:	0f 8e cc 01 00 00    	jle    1874 <main+0x614>
    16a8:	45 31 e4             	xor    r12d,r12d
    16ab:	4c 8d bc 24 30 03 00 	lea    r15,[rsp+0x330]
    16b2:	00
    16b3:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
    16b8:	0f ae e8             	lfence
    16bb:	0f 01 f9             	rdtscp
    16be:	48 c1 e2 20          	shl    rdx,0x20
    16c2:	89 c0                	mov    eax,eax
    16c4:	4c 8b 44 24 50       	mov    r8,QWORD PTR [rsp+0x50]
    16c9:	48 09 c2             	or     rdx,rax
    16cc:	48 89 d6             	mov    rsi,rdx
    16cf:	4d 85 c0             	test   r8,r8
    16d2:	74 24                	je     16f8 <main+0x498>
    16d4:	31 ff                	xor    edi,edi
    16d6:	31 c9                	xor    ecx,ecx
    16d8:	eb 10                	jmp    16ea <main+0x48a>
    16da:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    16e0:	48 89 c8             	mov    rax,rcx
    16e3:	83 e0 0f             	and    eax,0xf
    16e6:	48 8b 3c c3          	mov    rdi,QWORD PTR [rbx+rax*8]
    16ea:	e8 81 04 00 00       	call   1b70 <victim_function>
    16ef:	48 83 c1 01          	add    rcx,0x1
    16f3:	4c 39 c1             	cmp    rcx,r8
    16f6:	75 e8                	jne    16e0 <main+0x480>
    16f8:	0f ae e8             	lfence
    16fb:	0f 01 f9             	rdtscp
    16fe:	48 89 d1             	mov    rcx,rdx
    1701:	89 c0                	mov    eax,eax
    1703:	4c 8b 44 24 50       	mov    r8,QWORD PTR [rsp+0x50]
    1708:	48 c1 e1 20          	shl    rcx,0x20
    170c:	48 09 c1             	or     rcx,rax
    170f:	48 29 f1             	sub    rcx,rsi
    1712:	0f 88 08 03 00 00    	js     1a20 <main+0x7c0>
    1718:	66 0f ef c0          	pxor   xmm0,xmm0
    171c:	f2 48 0f 2a c1       	cvtsi2sd xmm0,rcx
    1721:	4d 85 c0             	test   r8,r8
    1724:	0f 88 ce 02 00 00    	js     19f8 <main+0x798>
    172a:	66 0f ef c9          	pxor   xmm1,xmm1
    172e:	f2 49 0f 2a c8       	cvtsi2sd xmm1,r8
    1733:	f2 0f 5e c1          	divsd  xmm0,xmm1
    1737:	4c 89 ee             	mov    rsi,r13
    173a:	48 89 ef             	mov    rdi,rbp
    173d:	48 89 4c 24 18       	mov    QWORD PTR [rsp+0x18],rcx
    1742:	4c 89 44 24 10       	mov    QWORD PTR [rsp+0x10],r8
    1747:	f2 0f 11 44 24 08    	movsd  QWORD PTR [rsp+0x8],xmm0
    174d:	e8 7e 06 00 00       	call   1dd0 <csv_write_quoted>
    1752:	48 89 ee             	mov    rsi,rbp
    1755:	bf 2c 00 00 00       	mov    edi,0x2c
    175a:	e8 81 fa ff ff       	call   11e0 <fputc@plt>
    175f:	48 8b 74 24 38       	mov    rsi,QWORD PTR [rsp+0x38]
    1764:	48 89 ef             	mov    rdi,rbp
    1767:	e8 64 06 00 00       	call   1dd0 <csv_write_quoted>
    176c:	48 89 ee             	mov    rsi,rbp
    176f:	bf 2c 00 00 00       	mov    edi,0x2c
    1774:	e8 67 fa ff ff       	call   11e0 <fputc@plt>
    1779:	48 8b 74 24 28       	mov    rsi,QWORD PTR [rsp+0x28]
    177e:	48 89 ef             	mov    rdi,rbp
    1781:	e8 4a 06 00 00       	call   1dd0 <csv_write_quoted>
    1786:	48 89 ee             	mov    rsi,rbp
    1789:	bf 2c 00 00 00       	mov    edi,0x2c
    178e:	e8 4d fa ff ff       	call   11e0 <fputc@plt>
    1793:	48 8b 74 24 30       	mov    rsi,QWORD PTR [rsp+0x30]
    1798:	48 89 ef             	mov    rdi,rbp
    179b:	e8 30 06 00 00       	call   1dd0 <csv_write_quoted>
    17a0:	48 89 ee             	mov    rsi,rbp
    17a3:	bf 2c 00 00 00       	mov    edi,0x2c
    17a8:	e8 33 fa ff ff       	call   11e0 <fputc@plt>
    17ad:	48 8b 74 24 40       	mov    rsi,QWORD PTR [rsp+0x40]
    17b2:	48 89 ef             	mov    rdi,rbp
    17b5:	e8 16 06 00 00       	call   1dd0 <csv_write_quoted>
    17ba:	48 89 ee             	mov    rsi,rbp
    17bd:	bf 2c 00 00 00       	mov    edi,0x2c
    17c2:	e8 19 fa ff ff       	call   11e0 <fputc@plt>
    17c7:	48 8b 74 24 48       	mov    rsi,QWORD PTR [rsp+0x48]
    17cc:	48 89 ef             	mov    rdi,rbp
    17cf:	e8 fc 05 00 00       	call   1dd0 <csv_write_quoted>
    17d4:	48 89 ee             	mov    rsi,rbp
    17d7:	bf 2c 00 00 00       	mov    edi,0x2c
    17dc:	e8 ff f9 ff ff       	call   11e0 <fputc@plt>
    17e1:	4c 89 fe             	mov    rsi,r15
    17e4:	48 89 ef             	mov    rdi,rbp
    17e7:	e8 e4 05 00 00       	call   1dd0 <csv_write_quoted>
    17ec:	48 89 ee             	mov    rsi,rbp
    17ef:	bf 2c 00 00 00       	mov    edi,0x2c
    17f4:	e8 e7 f9 ff ff       	call   11e0 <fputc@plt>
    17f9:	4c 89 f6             	mov    rsi,r14
    17fc:	48 89 ef             	mov    rdi,rbp
    17ff:	e8 cc 05 00 00       	call   1dd0 <csv_write_quoted>
    1804:	48 89 ee             	mov    rsi,rbp
    1807:	bf 2c 00 00 00       	mov    edi,0x2c
    180c:	e8 cf f9 ff ff       	call   11e0 <fputc@plt>
    1811:	48 8b 74 24 20       	mov    rsi,QWORD PTR [rsp+0x20]
    1816:	48 89 ef             	mov    rdi,rbp
    1819:	e8 b2 05 00 00       	call   1dd0 <csv_write_quoted>
    181e:	48 89 ee             	mov    rsi,rbp
    1821:	bf 2c 00 00 00       	mov    edi,0x2c
    1826:	e8 b5 f9 ff ff       	call   11e0 <fputc@plt>
    182b:	48 83 ec 08          	sub    rsp,0x8
    182f:	45 89 e1             	mov    r9d,r12d
    1832:	48 89 ef             	mov    rdi,rbp
    1835:	48 8b 4c 24 20       	mov    rcx,QWORD PTR [rsp+0x20]
    183a:	48 8d 15 5a 08 00 00 	lea    rdx,[rip+0x85a]        # 209b <_IO_stdin_used+0x9b>
    1841:	be 01 00 00 00       	mov    esi,0x1
    1846:	b8 01 00 00 00       	mov    eax,0x1
    184b:	41 83 c4 01          	add    r12d,0x1
    184f:	51                   	push   rcx
    1850:	f2 0f 10 44 24 18    	movsd  xmm0,QWORD PTR [rsp+0x18]
    1856:	48 8d 0d 35 08 00 00 	lea    rcx,[rip+0x835]        # 2092 <_IO_stdin_used+0x92>
    185d:	4c 8b 44 24 20       	mov    r8,QWORD PTR [rsp+0x20]
    1862:	e8 d9 f9 ff ff       	call   1240 <__fprintf_chk@plt>
    1867:	58                   	pop    rax
    1868:	5a                   	pop    rdx
    1869:	44 3b 64 24 58       	cmp    r12d,DWORD PTR [rsp+0x58]
    186e:	0f 8c 44 fe ff ff    	jl     16b8 <main+0x458>
    1874:	48 39 2d c5 27 00 00 	cmp    QWORD PTR [rip+0x27c5],rbp        # 4040 <stdout@GLIBC_2.2.5>
    187b:	74 08                	je     1885 <main+0x625>
    187d:	48 89 ef             	mov    rdi,rbp
    1880:	e8 fb f8 ff ff       	call   1180 <fclose@plt>
    1885:	45 31 c0             	xor    r8d,r8d
    1888:	e9 24 fb ff ff       	jmp    13b1 <main+0x151>
    188d:	0f 1f 00             	nop    DWORD PTR [rax]
    1890:	48 8b 54 24 08       	mov    rdx,QWORD PTR [rsp+0x8]
    1895:	48 63 c3             	movsxd rax,ebx
    1898:	48 8d 74 24 50       	lea    rsi,[rsp+0x50]
    189d:	48 8b 3c c2          	mov    rdi,QWORD PTR [rdx+rax*8]
    18a1:	e8 fa 02 00 00       	call   1ba0 <parse_ull>
    18a6:	85 c0                	test   eax,eax
    18a8:	0f 84 50 fa ff ff    	je     12fe <main+0x9e>
    18ae:	48 8d 15 2b 09 00 00 	lea    rdx,[rip+0x92b]        # 21e0 <_IO_stdin_used+0x1e0>
    18b5:	48 8b 3d a4 27 00 00 	mov    rdi,QWORD PTR [rip+0x27a4]        # 4060 <stderr@GLIBC_2.2.5>
    18bc:	be 01 00 00 00       	mov    esi,0x1
    18c1:	31 c0                	xor    eax,eax
    18c3:	e8 78 f9 ff ff       	call   1240 <__fprintf_chk@plt>
    18c8:	41 b8 02 00 00 00    	mov    r8d,0x2
    18ce:	e9 de fa ff ff       	jmp    13b1 <main+0x151>
    18d3:	89 44 24 10          	mov    DWORD PTR [rsp+0x10],eax
    18d7:	48 8b 44 24 08       	mov    rax,QWORD PTR [rsp+0x8]
    18dc:	be 01 00 00 00       	mov    esi,0x1
    18e1:	48 8d 15 d0 07 00 00 	lea    rdx,[rip+0x7d0]        # 20b8 <_IO_stdin_used+0xb8>
    18e8:	48 8b 3d 71 27 00 00 	mov    rdi,QWORD PTR [rip+0x2771]        # 4060 <stderr@GLIBC_2.2.5>
    18ef:	48 8b 08             	mov    rcx,QWORD PTR [rax]
    18f2:	31 c0                	xor    eax,eax
    18f4:	e8 47 f9 ff ff       	call   1240 <__fprintf_chk@plt>
    18f9:	44 8b 44 24 10       	mov    r8d,DWORD PTR [rsp+0x10]
    18fe:	e9 ae fa ff ff       	jmp    13b1 <main+0x151>
    1903:	4c 8d bc 24 30 03 00 	lea    r15,[rsp+0x330]
    190a:	00
    190b:	48 8d 8c 24 e2 00 00 	lea    rcx,[rsp+0xe2]
    1912:	00
    1913:	4c 89 e2             	mov    rdx,r12
    1916:	be 80 00 00 00       	mov    esi,0x80
    191b:	4c 89 ff             	mov    rdi,r15
    191e:	e8 8d f8 ff ff       	call   11b0 <snprintf@plt>
    1923:	e9 ea fc ff ff       	jmp    1612 <main+0x3b2>
    1928:	48 b8 75 6e 6b 6e 6f 	movabs rax,0x6e776f6e6b6e75
    192f:	77 6e 00
    1932:	48 89 84 24 f0 02 00 	mov    QWORD PTR [rsp+0x2f0],rax
    1939:	00
    193a:	e9 86 fc ff ff       	jmp    15c5 <main+0x365>
    193f:	48 b8 75 6e 6b 6e 6f 	movabs rax,0x6e776f6e6b6e75
    1946:	77 6e 00
    1949:	48 89 84 24 d0 02 00 	mov    QWORD PTR [rsp+0x2d0],rax
    1950:	00
    1951:	e9 46 fc ff ff       	jmp    159c <main+0x33c>
    1956:	48 b8 75 6e 6b 6e 6f 	movabs rax,0x6e776f6e6b6e75
    195d:	77 6e 00
    1960:	48 89 84 24 b0 02 00 	mov    QWORD PTR [rsp+0x2b0],rax
    1967:	00
    1968:	e9 06 fc ff ff       	jmp    1573 <main+0x313>
    196d:	48 b8 75 6e 6b 6e 6f 	movabs rax,0x6e776f6e6b6e75
    1974:	77 6e 00
    1977:	48 89 84 24 30 02 00 	mov    QWORD PTR [rsp+0x230],rax
    197e:	00
    197f:	e9 c6 fb ff ff       	jmp    154a <main+0x2ea>
    1984:	48 b8 75 6e 6b 6e 6f 	movabs rax,0x6e776f6e6b6e75
    198b:	77 6e 00
    198e:	48 89 84 24 10 03 00 	mov    QWORD PTR [rsp+0x310],rax
    1995:	00
    1996:	e9 53 fc ff ff       	jmp    15ee <main+0x38e>
    199b:	48 8b 7c 24 18       	mov    rdi,QWORD PTR [rsp+0x18]
    19a0:	48 8d 35 a8 06 00 00 	lea    rsi,[rip+0x6a8]        # 204f <_IO_stdin_used+0x4f>
    19a7:	e8 74 f8 ff ff       	call   1220 <fopen@plt>
    19ac:	48 89 c5             	mov    rbp,rax
    19af:	48 85 c0             	test   rax,rax
    19b2:	0f 85 00 fb ff ff    	jne    14b8 <main+0x258>
    19b8:	e8 a3 f7 ff ff       	call   1160 <__errno_location@plt>
    19bd:	8b 38                	mov    edi,DWORD PTR [rax]
    19bf:	e8 8c f8 ff ff       	call   1250 <strerror@plt>
    19c4:	48 8b 4c 24 18       	mov    rcx,QWORD PTR [rsp+0x18]
    19c9:	be 01 00 00 00       	mov    esi,0x1
    19ce:	48 8b 3d 8b 26 00 00 	mov    rdi,QWORD PTR [rip+0x268b]        # 4060 <stderr@GLIBC_2.2.5>
    19d5:	49 89 c0             	mov    r8,rax
    19d8:	48 8d 15 e9 08 00 00 	lea    rdx,[rip+0x8e9]        # 22c8 <_IO_stdin_used+0x2c8>
    19df:	31 c0                	xor    eax,eax
    19e1:	e8 5a f8 ff ff       	call   1240 <__fprintf_chk@plt>
    19e6:	41 b8 01 00 00 00    	mov    r8d,0x1
    19ec:	e9 c0 f9 ff ff       	jmp    13b1 <main+0x151>
    19f1:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    19f8:	4c 89 c0             	mov    rax,r8
    19fb:	4c 89 c2             	mov    rdx,r8
    19fe:	66 0f ef c9          	pxor   xmm1,xmm1
    1a02:	48 d1 e8             	shr    rax,1
    1a05:	83 e2 01             	and    edx,0x1
    1a08:	48 09 d0             	or     rax,rdx
    1a0b:	f2 48 0f 2a c8       	cvtsi2sd xmm1,rax
    1a10:	f2 0f 58 c9          	addsd  xmm1,xmm1
    1a14:	e9 1a fd ff ff       	jmp    1733 <main+0x4d3>
    1a19:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    1a20:	48 89 c8             	mov    rax,rcx
    1a23:	48 89 ca             	mov    rdx,rcx
    1a26:	66 0f ef c0          	pxor   xmm0,xmm0
    1a2a:	48 d1 e8             	shr    rax,1
    1a2d:	83 e2 01             	and    edx,0x1
    1a30:	48 09 d0             	or     rax,rdx
    1a33:	f2 48 0f 2a c0       	cvtsi2sd xmm0,rax
    1a38:	f2 0f 58 c0          	addsd  xmm0,xmm0
    1a3c:	e9 e0 fc ff ff       	jmp    1721 <main+0x4c1>
    1a41:	48 8d 15 20 08 00 00 	lea    rdx,[rip+0x820]        # 2268 <_IO_stdin_used+0x268>
    1a48:	e9 68 fe ff ff       	jmp    18b5 <main+0x655>
    1a4d:	48 8d 15 44 08 00 00 	lea    rdx,[rip+0x844]        # 2298 <_IO_stdin_used+0x298>
    1a54:	e9 5c fe ff ff       	jmp    18b5 <main+0x655>
    1a59:	48 c7 44 24 20 00 00 	mov    QWORD PTR [rsp+0x20],0x0
    1a60:	00 00
    1a62:	48 8b 2d d7 25 00 00 	mov    rbp,QWORD PTR [rip+0x25d7]        # 4040 <stdout@GLIBC_2.2.5>
    1a69:	e9 4a fa ff ff       	jmp    14b8 <main+0x258>
    1a6e:	e8 2d f7 ff ff       	call   11a0 <__stack_chk_fail@plt>
    1a73:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    1a7a:	00 00 00
    1a7d:	0f 1f 00             	nop    DWORD PTR [rax]

0000000000001a80 <_start>:
    1a80:	f3 0f 1e fa          	endbr64
    1a84:	31 ed                	xor    ebp,ebp
    1a86:	49 89 d1             	mov    r9,rdx
    1a89:	5e                   	pop    rsi
    1a8a:	48 89 e2             	mov    rdx,rsp
    1a8d:	48 83 e4 f0          	and    rsp,0xfffffffffffffff0
    1a91:	50                   	push   rax
    1a92:	54                   	push   rsp
    1a93:	45 31 c0             	xor    r8d,r8d
    1a96:	31 c9                	xor    ecx,ecx
    1a98:	48 8d 3d c1 f7 ff ff 	lea    rdi,[rip+0xfffffffffffff7c1]        # 1260 <main>
    1a9f:	ff 15 33 25 00 00    	call   QWORD PTR [rip+0x2533]        # 3fd8 <__libc_start_main@GLIBC_2.34>
    1aa5:	f4                   	hlt
    1aa6:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    1aad:	00 00 00

0000000000001ab0 <deregister_tm_clones>:
    1ab0:	48 8d 3d 61 25 00 00 	lea    rdi,[rip+0x2561]        # 4018 <__TMC_END__>
    1ab7:	48 8d 05 5a 25 00 00 	lea    rax,[rip+0x255a]        # 4018 <__TMC_END__>
    1abe:	48 39 f8             	cmp    rax,rdi
    1ac1:	74 15                	je     1ad8 <deregister_tm_clones+0x28>
    1ac3:	48 8b 05 16 25 00 00 	mov    rax,QWORD PTR [rip+0x2516]        # 3fe0 <_ITM_deregisterTMCloneTable@Base>
    1aca:	48 85 c0             	test   rax,rax
    1acd:	74 09                	je     1ad8 <deregister_tm_clones+0x28>
    1acf:	ff e0                	jmp    rax
    1ad1:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    1ad8:	c3                   	ret
    1ad9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001ae0 <register_tm_clones>:
    1ae0:	48 8d 3d 31 25 00 00 	lea    rdi,[rip+0x2531]        # 4018 <__TMC_END__>
    1ae7:	48 8d 35 2a 25 00 00 	lea    rsi,[rip+0x252a]        # 4018 <__TMC_END__>
    1aee:	48 29 fe             	sub    rsi,rdi
    1af1:	48 89 f0             	mov    rax,rsi
    1af4:	48 c1 ee 3f          	shr    rsi,0x3f
    1af8:	48 c1 f8 03          	sar    rax,0x3
    1afc:	48 01 c6             	add    rsi,rax
    1aff:	48 d1 fe             	sar    rsi,1
    1b02:	74 14                	je     1b18 <register_tm_clones+0x38>
    1b04:	48 8b 05 e5 24 00 00 	mov    rax,QWORD PTR [rip+0x24e5]        # 3ff0 <_ITM_registerTMCloneTable@Base>
    1b0b:	48 85 c0             	test   rax,rax
    1b0e:	74 08                	je     1b18 <register_tm_clones+0x38>
    1b10:	ff e0                	jmp    rax
    1b12:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    1b18:	c3                   	ret
    1b19:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001b20 <__do_global_dtors_aux>:
    1b20:	f3 0f 1e fa          	endbr64
    1b24:	80 3d 3d 25 00 00 00 	cmp    BYTE PTR [rip+0x253d],0x0        # 4068 <completed.0>
    1b2b:	75 2b                	jne    1b58 <__do_global_dtors_aux+0x38>
    1b2d:	55                   	push   rbp
    1b2e:	48 83 3d c2 24 00 00 	cmp    QWORD PTR [rip+0x24c2],0x0        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    1b35:	00
    1b36:	48 89 e5             	mov    rbp,rsp
    1b39:	74 0c                	je     1b47 <__do_global_dtors_aux+0x27>
    1b3b:	48 8b 3d c6 24 00 00 	mov    rdi,QWORD PTR [rip+0x24c6]        # 4008 <__dso_handle>
    1b42:	e8 f9 f5 ff ff       	call   1140 <__cxa_finalize@plt>
    1b47:	e8 64 ff ff ff       	call   1ab0 <deregister_tm_clones>
    1b4c:	c6 05 15 25 00 00 01 	mov    BYTE PTR [rip+0x2515],0x1        # 4068 <completed.0>
    1b53:	5d                   	pop    rbp
    1b54:	c3                   	ret
    1b55:	0f 1f 00             	nop    DWORD PTR [rax]
    1b58:	c3                   	ret
    1b59:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001b60 <frame_dummy>:
    1b60:	f3 0f 1e fa          	endbr64
    1b64:	e9 77 ff ff ff       	jmp    1ae0 <register_tm_clones>
    1b69:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001b70 <victim_function>:
    1b70:	8b 05 9a 24 00 00    	mov    eax,DWORD PTR [rip+0x249a]        # 4010 <array1_size>
    1b76:	48 39 f8             	cmp    rax,rdi
    1b79:	76 21                	jbe    1b9c <victim_function+0x2c>
    1b7b:	48 8d 05 be 08 00 00 	lea    rax,[rip+0x8be]        # 2440 <array1>
    1b82:	48 8d 15 37 25 00 00 	lea    rdx,[rip+0x2537]        # 40c0 <array2>
    1b89:	0f b6 04 38          	movzx  eax,BYTE PTR [rax+rdi*1]
    1b8d:	c1 e0 09             	shl    eax,0x9
    1b90:	48 98                	cdqe
    1b92:	0f b6 04 02          	movzx  eax,BYTE PTR [rdx+rax*1]
    1b96:	20 05 e4 24 00 00    	and    BYTE PTR [rip+0x24e4],al        # 4080 <temp>
    1b9c:	c3                   	ret
    1b9d:	0f 1f 00             	nop    DWORD PTR [rax]

0000000000001ba0 <parse_ull>:
    1ba0:	41 54                	push   r12
    1ba2:	55                   	push   rbp
    1ba3:	53                   	push   rbx
    1ba4:	48 83 ec 10          	sub    rsp,0x10
    1ba8:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    1baf:	00 00
    1bb1:	48 89 44 24 08       	mov    QWORD PTR [rsp+0x8],rax
    1bb6:	31 c0                	xor    eax,eax
    1bb8:	48 85 ff             	test   rdi,rdi
    1bbb:	74 6b                	je     1c28 <parse_ull+0x88>
    1bbd:	80 3f 00             	cmp    BYTE PTR [rdi],0x0
    1bc0:	48 89 fd             	mov    rbp,rdi
    1bc3:	74 63                	je     1c28 <parse_ull+0x88>
    1bc5:	49 89 f4             	mov    r12,rsi
    1bc8:	e8 93 f5 ff ff       	call   1160 <__errno_location@plt>
    1bcd:	48 89 e6             	mov    rsi,rsp
    1bd0:	ba 0a 00 00 00       	mov    edx,0xa
    1bd5:	48 89 ef             	mov    rdi,rbp
    1bd8:	c7 00 00 00 00 00    	mov    DWORD PTR [rax],0x0
    1bde:	48 89 c3             	mov    rbx,rax
    1be1:	48 c7 04 24 00 00 00 	mov    QWORD PTR [rsp],0x0
    1be8:	00
    1be9:	e8 12 f6 ff ff       	call   1200 <strtoull@plt>
    1bee:	44 8b 03             	mov    r8d,DWORD PTR [rbx]
    1bf1:	45 85 c0             	test   r8d,r8d
    1bf4:	75 32                	jne    1c28 <parse_ull+0x88>
    1bf6:	48 8b 14 24          	mov    rdx,QWORD PTR [rsp]
    1bfa:	48 85 d2             	test   rdx,rdx
    1bfd:	74 29                	je     1c28 <parse_ull+0x88>
    1bff:	80 3a 00             	cmp    BYTE PTR [rdx],0x0
    1c02:	75 24                	jne    1c28 <parse_ull+0x88>
    1c04:	49 89 04 24          	mov    QWORD PTR [r12],rax
    1c08:	48 8b 44 24 08       	mov    rax,QWORD PTR [rsp+0x8]
    1c0d:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
    1c14:	00 00
    1c16:	75 18                	jne    1c30 <parse_ull+0x90>
    1c18:	48 83 c4 10          	add    rsp,0x10
    1c1c:	44 89 c0             	mov    eax,r8d
    1c1f:	5b                   	pop    rbx
    1c20:	5d                   	pop    rbp
    1c21:	41 5c                	pop    r12
    1c23:	c3                   	ret
    1c24:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
    1c28:	41 b8 ff ff ff ff    	mov    r8d,0xffffffff
    1c2e:	eb d8                	jmp    1c08 <parse_ull+0x68>
    1c30:	e8 6b f5 ff ff       	call   11a0 <__stack_chk_fail@plt>
    1c35:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
    1c3c:	00 00 00 00

0000000000001c40 <read_cpuinfo_field>:
    1c40:	41 57                	push   r15
    1c42:	41 56                	push   r14
    1c44:	49 89 fe             	mov    r14,rdi
    1c47:	48 8d 3d b8 03 00 00 	lea    rdi,[rip+0x3b8]        # 2006 <_IO_stdin_used+0x6>
    1c4e:	41 55                	push   r13
    1c50:	49 89 d5             	mov    r13,rdx
    1c53:	41 54                	push   r12
    1c55:	55                   	push   rbp
    1c56:	53                   	push   rbx
    1c57:	48 81 ec 28 02 00 00 	sub    rsp,0x228
    1c5e:	48 89 74 24 08       	mov    QWORD PTR [rsp+0x8],rsi
    1c63:	48 8d 35 9a 03 00 00 	lea    rsi,[rip+0x39a]        # 2004 <_IO_stdin_used+0x4>
    1c6a:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    1c71:	00 00
    1c73:	48 89 84 24 18 02 00 	mov    QWORD PTR [rsp+0x218],rax
    1c7a:	00
    1c7b:	31 c0                	xor    eax,eax
    1c7d:	e8 9e f5 ff ff       	call   1220 <fopen@plt>
    1c82:	48 85 c0             	test   rax,rax
    1c85:	0f 84 2f 01 00 00    	je     1dba <read_cpuinfo_field+0x17a>
    1c8b:	4c 89 f7             	mov    rdi,r14
    1c8e:	48 89 c5             	mov    rbp,rax
    1c91:	4c 8d 64 24 10       	lea    r12,[rsp+0x10]
    1c96:	e8 f5 f4 ff ff       	call   1190 <strlen@plt>
    1c9b:	48 89 c3             	mov    rbx,rax
    1c9e:	48 89 ea             	mov    rdx,rbp
    1ca1:	be 00 02 00 00       	mov    esi,0x200
    1ca6:	4c 89 e7             	mov    rdi,r12
    1ca9:	e8 42 f5 ff ff       	call   11f0 <fgets@plt>
    1cae:	48 85 c0             	test   rax,rax
    1cb1:	0f 84 f5 00 00 00    	je     1dac <read_cpuinfo_field+0x16c>
    1cb7:	48 89 da             	mov    rdx,rbx
    1cba:	4c 89 f6             	mov    rsi,r14
    1cbd:	4c 89 e7             	mov    rdi,r12
    1cc0:	e8 ab f4 ff ff       	call   1170 <strncmp@plt>
    1cc5:	41 89 c7             	mov    r15d,eax
    1cc8:	85 c0                	test   eax,eax
    1cca:	75 d2                	jne    1c9e <read_cpuinfo_field+0x5e>
    1ccc:	49 8d 04 1c          	lea    rax,[r12+rbx*1]
    1cd0:	0f b6 10             	movzx  edx,BYTE PTR [rax]
    1cd3:	80 fa 20             	cmp    dl,0x20
    1cd6:	75 15                	jne    1ced <read_cpuinfo_field+0xad>
    1cd8:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
    1cdf:	00
    1ce0:	0f b6 50 01          	movzx  edx,BYTE PTR [rax+0x1]
    1ce4:	48 83 c0 01          	add    rax,0x1
    1ce8:	80 fa 20             	cmp    dl,0x20
    1ceb:	74 f3                	je     1ce0 <read_cpuinfo_field+0xa0>
    1ced:	80 fa 09             	cmp    dl,0x9
    1cf0:	74 ee                	je     1ce0 <read_cpuinfo_field+0xa0>
    1cf2:	80 fa 3a             	cmp    dl,0x3a
    1cf5:	75 a7                	jne    1c9e <read_cpuinfo_field+0x5e>
    1cf7:	4c 8d 70 01          	lea    r14,[rax+0x1]
    1cfb:	0f b6 40 01          	movzx  eax,BYTE PTR [rax+0x1]
    1cff:	3c 09                	cmp    al,0x9
    1d01:	74 0d                	je     1d10 <read_cpuinfo_field+0xd0>
    1d03:	3c 20                	cmp    al,0x20
    1d05:	75 1a                	jne    1d21 <read_cpuinfo_field+0xe1>
    1d07:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
    1d0e:	00 00
    1d10:	41 0f b6 46 01       	movzx  eax,BYTE PTR [r14+0x1]
    1d15:	49 83 c6 01          	add    r14,0x1
    1d19:	3c 20                	cmp    al,0x20
    1d1b:	74 f3                	je     1d10 <read_cpuinfo_field+0xd0>
    1d1d:	3c 09                	cmp    al,0x9
    1d1f:	74 ef                	je     1d10 <read_cpuinfo_field+0xd0>
    1d21:	4c 89 f7             	mov    rdi,r14
    1d24:	e8 67 f4 ff ff       	call   1190 <strlen@plt>
    1d29:	4c 01 f0             	add    rax,r14
    1d2c:	4c 39 f0             	cmp    rax,r14
    1d2f:	76 18                	jbe    1d49 <read_cpuinfo_field+0x109>
    1d31:	48 b9 ff d9 ff ff fe 	movabs rcx,0xfffffffeffffd9ff
    1d38:	ff ff ff
    1d3b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
    1d40:	0f b6 50 ff          	movzx  edx,BYTE PTR [rax-0x1]
    1d44:	80 fa 20             	cmp    dl,0x20
    1d47:	76 4f                	jbe    1d98 <read_cpuinfo_field+0x158>
    1d49:	48 8b 7c 24 08       	mov    rdi,QWORD PTR [rsp+0x8]
    1d4e:	4c 89 f1             	mov    rcx,r14
    1d51:	4c 89 ee             	mov    rsi,r13
    1d54:	31 c0                	xor    eax,eax
    1d56:	48 8d 15 b7 02 00 00 	lea    rdx,[rip+0x2b7]        # 2014 <_IO_stdin_used+0x14>
    1d5d:	e8 4e f4 ff ff       	call   11b0 <snprintf@plt>
    1d62:	48 89 ef             	mov    rdi,rbp
    1d65:	e8 16 f4 ff ff       	call   1180 <fclose@plt>
    1d6a:	48 8b 84 24 18 02 00 	mov    rax,QWORD PTR [rsp+0x218]
    1d71:	00
    1d72:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
    1d79:	00 00
    1d7b:	75 43                	jne    1dc0 <read_cpuinfo_field+0x180>
    1d7d:	48 81 c4 28 02 00 00 	add    rsp,0x228
    1d84:	44 89 f8             	mov    eax,r15d
    1d87:	5b                   	pop    rbx
    1d88:	5d                   	pop    rbp
    1d89:	41 5c                	pop    r12
    1d8b:	41 5d                	pop    r13
    1d8d:	41 5e                	pop    r14
    1d8f:	41 5f                	pop    r15
    1d91:	c3                   	ret
    1d92:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    1d98:	48 0f a3 d1          	bt     rcx,rdx
    1d9c:	72 ab                	jb     1d49 <read_cpuinfo_field+0x109>
    1d9e:	48 83 e8 01          	sub    rax,0x1
    1da2:	c6 00 00             	mov    BYTE PTR [rax],0x0
    1da5:	4c 39 f0             	cmp    rax,r14
    1da8:	75 96                	jne    1d40 <read_cpuinfo_field+0x100>
    1daa:	eb 9d                	jmp    1d49 <read_cpuinfo_field+0x109>
    1dac:	48 89 ef             	mov    rdi,rbp
    1daf:	41 83 cf ff          	or     r15d,0xffffffff
    1db3:	e8 c8 f3 ff ff       	call   1180 <fclose@plt>
    1db8:	eb b0                	jmp    1d6a <read_cpuinfo_field+0x12a>
    1dba:	41 83 cf ff          	or     r15d,0xffffffff
    1dbe:	eb aa                	jmp    1d6a <read_cpuinfo_field+0x12a>
    1dc0:	e8 db f3 ff ff       	call   11a0 <__stack_chk_fail@plt>
    1dc5:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
    1dcc:	00 00 00 00

0000000000001dd0 <csv_write_quoted>:
    1dd0:	55                   	push   rbp
    1dd1:	48 89 fd             	mov    rbp,rdi
    1dd4:	53                   	push   rbx
    1dd5:	48 89 f3             	mov    rbx,rsi
    1dd8:	48 89 fe             	mov    rsi,rdi
    1ddb:	bf 22 00 00 00       	mov    edi,0x22
    1de0:	48 83 ec 08          	sub    rsp,0x8
    1de4:	e8 f7 f3 ff ff       	call   11e0 <fputc@plt>
    1de9:	0f b6 03             	movzx  eax,BYTE PTR [rbx]
    1dec:	84 c0                	test   al,al
    1dee:	75 19                	jne    1e09 <csv_write_quoted+0x39>
    1df0:	eb 42                	jmp    1e34 <csv_write_quoted+0x64>
    1df2:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    1df8:	e8 e3 f3 ff ff       	call   11e0 <fputc@plt>
    1dfd:	0f b6 43 01          	movzx  eax,BYTE PTR [rbx+0x1]
    1e01:	48 83 c3 01          	add    rbx,0x1
    1e05:	84 c0                	test   al,al
    1e07:	74 2b                	je     1e34 <csv_write_quoted+0x64>
    1e09:	3c 22                	cmp    al,0x22
    1e0b:	74 43                	je     1e50 <csv_write_quoted+0x80>
    1e0d:	0f be 3b             	movsx  edi,BYTE PTR [rbx]
    1e10:	48 89 ee             	mov    rsi,rbp
    1e13:	40 80 ff 0a          	cmp    dil,0xa
    1e17:	74 06                	je     1e1f <csv_write_quoted+0x4f>
    1e19:	40 80 ff 0d          	cmp    dil,0xd
    1e1d:	75 d9                	jne    1df8 <csv_write_quoted+0x28>
    1e1f:	bf 20 00 00 00       	mov    edi,0x20
    1e24:	48 83 c3 01          	add    rbx,0x1
    1e28:	e8 b3 f3 ff ff       	call   11e0 <fputc@plt>
    1e2d:	0f b6 03             	movzx  eax,BYTE PTR [rbx]
    1e30:	84 c0                	test   al,al
    1e32:	75 d5                	jne    1e09 <csv_write_quoted+0x39>
    1e34:	48 83 c4 08          	add    rsp,0x8
    1e38:	48 89 ee             	mov    rsi,rbp
    1e3b:	bf 22 00 00 00       	mov    edi,0x22
    1e40:	5b                   	pop    rbx
    1e41:	5d                   	pop    rbp
    1e42:	e9 99 f3 ff ff       	jmp    11e0 <fputc@plt>
    1e47:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
    1e4e:	00 00
    1e50:	48 89 ee             	mov    rsi,rbp
    1e53:	bf 22 00 00 00       	mov    edi,0x22
    1e58:	e8 83 f3 ff ff       	call   11e0 <fputc@plt>
    1e5d:	eb ae                	jmp    1e0d <csv_write_quoted+0x3d>

Disassembly of section .fini:

0000000000001e60 <_fini>:
    1e60:	f3 0f 1e fa          	endbr64
    1e64:	48 83 ec 08          	sub    rsp,0x8
    1e68:	48 83 c4 08          	add    rsp,0x8
    1e6c:	c3                   	ret
