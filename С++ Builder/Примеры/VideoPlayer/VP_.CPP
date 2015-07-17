/*
   Простой видеоплеер. Демонстрирует использование:
     - компонента MediaPlayer для воспроизведения небольших
       видео роликов (формат AVI);
     - компонента SpeedButton.

   Змаечание. Если окно программы, когда воспроизведение клипа закончено,
   перекрыть другим окном, то кадр будет испорчен. Чтобы этого не было,
   надо написать функцию обработки события OnPaint для формы или использовать
   в качестве экрана компонет Panel или Image. В последнем случае надо
   соответствующим образом установить значение свойства MediaPlayer->Display .
*/

#include <vcl.h>
#pragma hdrstop

#include "vp_.h"

#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;


__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}

// обработка события Create
void __fastcall TForm1::FormCreate(TObject *Sender)
{
    MediaPlayer1->Display = Form1; // отображение ролика на поверхности формы
}

// возвращает размер кадра AVI файла
void __fastcall GetFrameSize(AnsiString f, int *w, int *h)
{
    // в заголовке AVI файла есть информация о размере кадра
    struct  {
        char     RIFF[4]; // строка RIFF
        long int nu_1[5]; // не используется
        char     AVIH[4]; // строка AVIH
        long int nu_2[9]; // не используется
        long int w;       // ширина кадра
        long int h;       // высота кадра
    } header;

    TFileStream *fs;   // поток, для чтения заголовка файла

    /* операторы объявления потока и его создания
    можно объединить: TFileStream *fs = new TFileStream(f,fmOpenRead); */

    fs = new TFileStream(f,fmOpenRead);   // открыть поток для чтения
    fs->Read(&header, sizeof(header));    // прочитать заголовок файла
    *w = header.w;
    *h = header.h;
    delete fs;
}

// щелчок на кнопке Eject (выбор видео клипа)
void __fastcall TForm1::SpeedButton1Click(TObject *Sender)
{
    OpenDialog1->Title = "Выбор клипа";
    OpenDialog1->InitialDir = "";
    OpenDialog1->FileName = "*.avi";
    if ( ! OpenDialog1->Execute() )
        return; // пользователь нажал кнопку Отмена

     /* При попытке открыть файл клипа, который уже открыт,
       возникает ошибка. */
    if ( MediaPlayer1->FileName == OpenDialog1->FileName )
        return;

    /* Пользователь выбрал клип. Зададим размер и положение "экрана",
       на котором будет выведен клип. Для этого надо знать размер
       кадров клипа. */

    int fw, fh;   // размер кадра клипа
    int top,left; // левый верхний угол экрана
    int sw, sh;   // размер экрана (ширина, высота)

    int mw, mh;   // максимально возможный размер экрана
                  // (определяется текущим размером формы)

    float kw, kh; // коэф-ты масштабирования кадра по ширине и высоте
    float k;      // коэффициент масштабирования кадра

    GetFrameSize(OpenDialog1->FileName,&fw, &fh);// получить размер кадра

    // вычислим максимально возможный размер кадра
    mw = Form1->ClientWidth;
    mh = Form1->SpeedButton1->Top-10;

    if ( fw < mw)
       kw = 1; // кадр по ширине меньше размера экрана
    else kw = (float) mw / fw;

    if ( fh < mh)
       kh = 1; // кадр по высоте меньше размера экрана
    else kh = (float) mh / fh;

    // масштабирование должно быть пропорциональным
    if ( kw < kh)
        k = kw;
    else k = kh;

   // здесь масштаб определен
   sw = fw * k; // ширина экрана
   sh = fh * k; // высота экрана

   left = (Form1->ClientWidth - sw) / 2;
   top = (SpeedButton1->Top - sh) / 2;

   MediaPlayer1->FileName = OpenDialog1->FileName;
   MediaPlayer1->Open();
   MediaPlayer1->DisplayRect = Rect(left,top,sw,sh);

   SpeedButton2->Enabled = True; // кнопка Play теперь доступна

    /* если размер кадра выбранного клипа меньше размера
       кадра предыдущего клипа, то экран (область формы)
       надо очистить */

    Form1->Canvas->FillRect(Rect(0,0,ClientWidth,SpeedButton1->Top));

   // активизируем процесс воспроизведения
   MediaPlayer1->Play();
   SpeedButton2->Down = True;
   SpeedButton2->Hint = "Stop";
   SpeedButton1->Enabled = False;
}

// щелчок на кнопке Play/Stop (воспроизведение/стоп)
void __fastcall TForm1::SpeedButton2Click(TObject *Sender)
{
    if (SpeedButton2->Down)
    {
        // нажата кнопка Play
        MediaPlayer1->Play();
        SpeedButton2->Hint = "Stop";
        SpeedButton1->Enabled = False; // кнопка Eject недоступна
    }
    else
    {
        // нажата кнопка Stop
        MediaPlayer1->Stop();
        SpeedButton2->Hint = "Play";
        SpeedButton1->Enabled = True; // кнопка Eject доступна
    }
}

// сигнал от плеера
void __fastcall TForm1::MediaPlayer1Notify(TObject *Sender)
{
    if ( ( MediaPlayer1->Mode == mpStopped ) && ( SpeedButton2->Down))
    {
        SpeedButton2->Down = False;   // "отжать" кнопку Play
        SpeedButton2->Hint = "Play";
        SpeedButton1->Enabled = True; // сделать доступной кнопку Eject
    }
}

