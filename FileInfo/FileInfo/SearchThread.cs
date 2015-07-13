using System;
using System.IO;
using System.Threading;
using System.Windows.Forms;
using System.Collections.Generic;

namespace FileInfo
{
    class SearchThread
    {
        private Thread T = null;
        private string Ext = string.Empty;
        private string Folder = string.Empty;
        private string SizeParam = string.Empty;
        private double totalFileSize = 0;

        public bool Stop = false;
        public bool Complete = true;
        public List<string> Result = new List<string>();

        /// <summary>
        /// формирование информации о файлах в новом потоке
        /// </summary>
        /// <param name="ext">разрешение файла</param>
        /// <param name="folder">Директория</param>
        /// <param name="sizeParam">Единица изменения (байт, килобайт, мегабайт, гигабайт) </param>
        public void Start(string ext, string folder, string sizeParam)
        {
            Ext = ext;
            Folder = folder;
            SizeParam = sizeParam; 

            T = new Thread(search);

            if (Result.Count != 0)
            {
                Result.Clear();
            }

            Stop = false;
            T.Start();
        }

        /// <summary>
        /// поиска файлов
        /// </summary>
        private void search()
        {
            Complete = false;
            totalFileSize = 0;
            DirectoryInfo di = new DirectoryInfo(Folder);
            walkDirectoryTree(di);

            //lock (Result)
            {
                Result.Add(string.Format("Общий размер: {0:0.00} {1} ({2} файлов).",
                           sizeConversion(totalFileSize), SizeParam, Result.Count));

            }
            Complete = true;

            MessageBox.Show("Обработка данных завершена.", "Информация", 
                            MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        /// <summary>
        /// преобразование размера в соответствии с выбранной емкостью
        /// </summary>
        /// <param name="fileSize">размер файла в байтах</param>
        /// <returns></returns>
        private double sizeConversion(double fileSize)
        {
            switch (SizeParam)
            {
                case "килобайт":
                    fileSize = fileSize / 1024;
                    break;

                case "мегабайт":
                    fileSize = fileSize / 1024 / 1024;
                    break;

                case "гигабайт":
                    fileSize = fileSize / 1024 / 1024 / 1024;
                    break;
            }
            
            return fileSize;
        }

        /// <summary>
        /// получение информации о файлах в каталоге
        /// </summary>
        /// <param name="root">родительский каталог</param>
        /// <returns></returns>
        private System.IO.FileInfo[] getFiles(System.IO.DirectoryInfo root)
        {
            System.IO.FileInfo[] files = null;

            try
            {
                files = root.GetFiles("*.*"); 
            }
            catch (UnauthorizedAccessException e)
            {
                lock (Result)
                {
                    Result.Add(string.Format("Доступ запрещен: {0}", e.Message));
                }
            }
            catch (DirectoryNotFoundException e)
            {
                lock (Result)
                {
                    Result.Add(string.Format("Невозможно прочитать каталог: {0}", e.Message));
                }
            }
            catch (Exception e)
            {
                lock (Result)
                {
                    Result.Add(e.Message);
                }
            }

            return files; 
        }

        /// <summary>
        /// рекурсивный обход каталогов
        /// </summary>
        /// <param name="root">родительский каталог</param>
        private void walkDirectoryTree(System.IO.DirectoryInfo root)
        {
            if (Stop)
            {
                return;
            }

            System.IO.FileInfo[] files = getFiles(root);

            if (files != null)
            {
                foreach (System.IO.FileInfo fi in files)
                {
                    if ((Ext == "*.*") | (fi.Extension == Ext.Substring(1)))
                    {
                        string filePath = fi.FullName;
                        double fileSize = sizeConversion(fi.Length);

                        lock (Result)
                        {
                            Result.Add(string.Format("{0} - {1:0.00} {2}.",
                                                     filePath, fileSize, SizeParam));
                        }

                        totalFileSize += fileSize;
                    }
                }

                System.IO.DirectoryInfo[] subDirs = root.GetDirectories();
                foreach (System.IO.DirectoryInfo dirInfo in subDirs)
                {
                    walkDirectoryTree(dirInfo);
                }
            }
        }
    }
}