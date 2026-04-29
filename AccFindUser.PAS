unit AccFindUser;

interface

uses
  WinTypes, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxGroupBox, cxRadioGroup,
  cxTextEdit, Menus, cxButtons, dxGDIPlusClasses, cxImage,
  adLayoutDetailsBtnForm, dxLayoutControlAdapters, System.Actions, Vcl.ActnList,
  dxLayoutContainer, adxButton, cxClasses, dxLayoutControl,
  dxLayoutcxEditAdapters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxNavigator, dxDateRanges, dxScrollbarAnnotations,
  cxButtonEdit, cxGridLevel, adcxGridTableView, cxGridCustomTableView,
  cxGridTableView, cxGridCustomView, cxGrid, sec;

type
  TfrmFindUserAcc = class(TfrmLayoutDetailsBtn)
    radSearchField: TcxRadioGroup;
    liSearchField: TdxLayoutItem;
    liSearchText: TdxLayoutItem;
    fldSearchTekst: TcxTextEdit;
    liExtSearch: TdxLayoutItem;
    grUsers: TcxGrid;
    gvUsers: TadcxGridTableView;
    gclUserstLoginName: TcxGridColumn;
    gclUserstName: TcxGridColumn;
    gclUsersMail: TcxGridColumn;
    gclUsersListIndex: TcxGridColumn;
    gclUsersAccDisabled: TadcxGridColumn;
    glUsers: TcxGridLevel;
    grpBasicSearch: TdxLayoutAutoCreatedGroup;
    gclUsersUserID: TadcxGridColumn;
    gclUsersLevel: TadcxGridColumn;
    liSwitchView: TdxLayoutItem;
    btnSwitchView: TcxButton;
    procedure FormShow(Sender: TObject);
    procedure btnSwitchViewClick(Sender: TObject);
    procedure acOKUpdate(Sender: TObject);
    procedure fldSearchTekstPropertiesChange(Sender: TObject);
    procedure acOKExecute(Sender: TObject);
  private
    FSecurity:TSecurity;
    FViewExt:Boolean;
    function GetSearchValue: string;
    function GetSearchField: integer;
    procedure LoadUserList;
    procedure SwitchView;
  public
    procedure SetData(ASecurity:TSecurity);
    property SearchValue: string read GetSearchValue;
    property SearchField: Integer read GetSearchField;
  end;

var
  frmFindUserAcc: TfrmFindUserAcc;

implementation

uses
  SysUtils, adStd, adcxgridFunc;

{$R *.DFM}

procedure TfrmFindUserAcc.acOKExecute(Sender: TObject);
begin
  inherited;
  ModalResult:=mrOk;
end;

procedure TfrmFindUserAcc.acOKUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled:=GetSearchValue<>'';
end;

procedure TfrmFindUserAcc.btnSwitchViewClick(Sender: TObject);
begin
  Modified:=true;
  FViewExt:=not FViewExt;
  SwitchView;
end;

procedure TfrmFindUserAcc.fldSearchTekstPropertiesChange(Sender: TObject);
begin
  Modified:=True;
end;

procedure TfrmFindUserAcc.FormShow(Sender: TObject);
begin
  inherited;
  LoadUserList;
  FViewExt:=false;
  SwitchView;
  if FViewExt then begin
     grUsers.SetFocus;
     if (gvUsers.DataController.RecordCount>0) and (gvUsers.DataController.FocusedRecordIndex<0) then
     try
      gvUsers.DataController.FocusedRecordIndex:=0;
     except
     end;
  end else
    fldSearchTekst.SetFocus;
end;


function TfrmFindUserAcc.GetSearchValue: string;
begin
  if FViewExt then begin
     with gvUsers.DataController do
       if FocusedRecordIndex >= 0 then
          Result :=xVarToString(Values[FocusedRecordIndex, gclUsersUserID.Index])
       else
          Result :='';
  end else begin
     Result := UpperCase(fldSearchTekst.Text);
  end
end;

function TfrmFindUserAcc.GetSearchField: integer;
begin
  if FViewExt then begin
     Result:=1
  end else begin
     Result := radSearchField.ItemIndex;
  end
end;



procedure TfrmFindUserAcc.LoadUserList;
var
  k, r, j :integer;
  secLevel: TSecLevel;
begin
 gvUsers.DataController.RecordCount := 0;
 gvUsers.BeginUpdate;
 for k := 1 to SecurityLevelCount do begin
    secLevel := FSecurity.Level(k);
    if Assigned(secLevel) then
      with secLevel do
        with gvUsers.DataController do
          for j:=0 to UsersCount - 1 do
          begin
            r := AppendRecord;
             Values[r, gclUserstLoginName.Index] := Trim(Users[j].LoginName);
             Values[r, gclUserstName.Index] := Trim(Users[j].Name);
             Values[r, gclUsersMail.Index]:= Users[j].MailAddress;
             Values[r, gclUsersUserID.Index]:=Users[j].UserID;
             Values[r, gclUsersLevel.Index]:= k;
          end;
 end;
 gvUsers.EndUpdate;
end;

procedure TfrmFindUserAcc.SetData(ASecurity: TSecurity);
begin
  FSecurity:=ASecurity;
end;

procedure TfrmFindUserAcc.SwitchView;
begin
   if FViewExt then  begin
      liExtSearch.Visible:=true;
      grpBasicSearch.Visible:=false;
      btnSwitchView.Caption:='Basic...';
      Self.Height:=600;
      Self.Width:=740;
   end else begin
      liExtSearch.Visible:=false;
      grpBasicSearch.Visible:=true;
      btnSwitchView.Caption:='Extended...';
      Self.Height:=200;
      Self.Width:=450;
   end;
   Self.Realign;
end;

end.
