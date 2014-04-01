///
///  �������� �������� �������
///
unit OPN;

interface

var
  gSOURCE, gRESULT, gSTACK: string;

///
///  ���:
///  0 - ������� ������ - ����������. ������ �������.
///  1 - �������� ���� � ����.
///  2 - �� ����� ���������� ���� � ���������.
///  3 - ������� ������� ������ � ������� �����.
///      ������������ ��� �������� ������.
///  4 - �������� ����������.
///  5 - ������ � �������� �������.
///
function Step: byte;

implementation

///
///  ���� ��� ��������������
///
function Step: byte;
  ///
  ///  �������� ��� �������
  ///
  ///  � ���������� �� ��� �����������
  ///  ��� ������ � �������� ������������
  ///
  function GetSymbolNum(c: char): byte;
  var
    SymbolNum: byte;
  begin
    SymbolNum:=0;
    case c of
     '"': SymbolNum:=1;
     '+': SymbolNum:=2;
     '-': SymbolNum:=2;
     '*': SymbolNum:=3;
     '^': SymbolNum:=3;
     '/': SymbolNum:=3;
     '(': SymbolNum:=4;
     ')': SymbolNum:=5;
    end;{case}
    Result:=SymbolNum;
  end;

  ///
  ///  ��: ���� �������� ������������� ������
  ///      � �����. ���� ���� ����, �� ������
  ///      �������� ����� 0.
  ///  ���: ��� ��������.
  ///  1. �������� ���� �� ������������� ������ � ����. (PUSH)
  ///  2. ���������� ���� �� ����� � ������. (POP)
  ///  3. ������� ����� �� ������������� ������ � �� �����.
  ///     (DELSOURCE, DELSTAK)
  ///  4. �������������� ������� ���������.
  ///  5. � �������� ������� ���������� ������.
  ///
  ///
  function GetCode(SourceNum,StackNum: byte): byte;
  const
    ///
    ///  ������� ������������
    ///
    ///  ����� � ������������� ������ �����������
    ///  ���� �������� ���� �������� ������� ����������
    ///  �� ����� � �� �������� � ������� �����.
    ///  � ������� ���������� ��� ����������� ��������.
    ///  �������� �������� ������ ����.
    ///
    ACodes: array [1..4,1..5] of byte=
    ((4,1,1,1,5),
     (2,2,1,1,2),
     (2,2,2,1,2),
     (5,1,1,1,3));
  var
    Code: byte;
  begin
    if StackNum=0 then
      Code:=1
    else
      Code:=ACodes[StackNum,SourceNum];
    Result:=Code;
  end;

  ///
  ///  ������� ������ �� ������������� ������
  ///
  procedure DELSOURCE;
  begin
    delete(gSOURCE,1,1);
  end;

  ///
  ///  ������� ������ � ������� �����
  ///
  procedure DELSTACK;
  begin
    delete(gSTACK,1,1);
  end;

  ///
  /// �������� ������ � ����
  ///
  procedure PUSH;
  begin
    gSTACK:=gSOURCE[1]+gSTACK;
    DELSOURCE;
  end;

  ///
  ///  �� ������� ����� ��������� ������
  ///  � ��������������� ������
  ///
  procedure POP;
  begin
    gRESULT:=gRESULT+gSTACK[1];
    DELSTACK;
  end;

  ///
  ///  ������ �������:
  ///  ��� ���������� �������� ���������� �� �����
  ///
  procedure GREEN;
  begin
    gRESULT:=gRESULT+gSOURCE[1];
    DELSOURCE;
  end;

var
  Code: byte;
begin
  Code:=0;
  if GetSymbolNum(gSOURCE[1])=0 then
    GREEN
  else
  begin
    if length(gSTACK)>0 then
      Code:=GetCode(GetSymbolNum(gSOURCE[1]),GetSymbolNum(gSTACK[1]))
    else
      Code:=GetCode(GetSymbolNum(gSOURCE[1]),0);
    ///
    ///  ��������� �������� � ����������� �� ����
    ///  �������� �� ������� ������������.
    ///
    case Code of
      1: PUSH;
      2: POP;
      3:
        begin
          DELSOURCE;
          DELSTACK;
        end;
      4:
        begin
          DELSTACK;
          DELSOURCE;
        end;
      5:
        begin
          gRESULT:='������ � �������� �������!'
        end;
    end;{case}
  end;
  Result:=Code;
end;

end.
