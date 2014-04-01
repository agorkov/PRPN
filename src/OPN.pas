///
///  Обратная польская нотация
///
unit OPN;

interface

var
  gSOURCE, gRESULT, gSTACK: string;

///
///  Вых:
///  0 - текущий символ - переменная. Зелёный коридор.
///  1 - помещаем знак в стек.
///  2 - из стека перемещаем знак в результат.
///  3 - удаляем текущий символ и вершину стека.
///      Используется для удаления скобок.
///  4 - успешное завершение.
///  5 - ошибка в исходной формуле.
///
function Step: byte;

implementation

///
///  Один шаг преобразования
///
function Step: byte;
  ///
  ///  Получаем код символа
  ///
  ///  В дальнейшем он нам понадобится
  ///  для работы с матрицей зависимостей
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
  ///  Вх: коды символов преобразуемой строки
  ///      и стека. Если стек пуст, то второй
  ///      параметр равен 0.
  ///  Вых: код действия.
  ///  1. Помещаем знак из преобразуемой строки в стек. (PUSH)
  ///  2. Перемещаем знак из стека в запись. (POP)
  ///  3. Удаляем знаки из преобразуемой строки и из стека.
  ///     (DELSOURCE, DELSTAK)
  ///  4. Преобразование успешно завершено.
  ///  5. В исходной формуле содержится ошибка.
  ///
  ///
  function GetCode(SourceNum,StackNum: byte): byte;
  const
    ///
    ///  Матрица зависимостей
    ///
    ///  Когда в преобразуемой строке встречается
    ///  знак операции наши действия зависят собственно
    ///  от знака и от элемента в вершине стека.
    ///  В матрице определены все необходимые действия.
    ///  Описания действий смотри выше.
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
  ///  Удаляем символ из преобразуемой строки
  ///
  procedure DELSOURCE;
  begin
    delete(gSOURCE,1,1);
  end;

  ///
  ///  Удаляем символ с вершины стека
  ///
  procedure DELSTACK;
  begin
    delete(gSTACK,1,1);
  end;

  ///
  /// Помещаем символ с стек
  ///
  procedure PUSH;
  begin
    gSTACK:=gSOURCE[1]+gSTACK;
    DELSOURCE;
  end;

  ///
  ///  Из вершины стека переносим символ
  ///  в преобразованную строку
  ///
  procedure POP;
  begin
    gRESULT:=gRESULT+gSTACK[1];
    DELSTACK;
  end;

  ///
  ///  Зелёный коридор:
  ///  все переменные напрямую передаются на выход
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
    ///  Выполняем действия в зависимости от кода
    ///  операций из матрицы зависимостей.
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
          gRESULT:='Ошибка в исходной формуле!'
        end;
    end;{case}
  end;
  Result:=Code;
end;

end.
