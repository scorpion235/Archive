using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Windows.Forms;
using System.Threading;
using System.Xml;

namespace Util
{
    class SearchThread
    {
        private Thread t = null;
        private List<string> extension = new List<string> { ".php", ".html", ".htm" };
        public bool Stop = false;
        public bool Complete = true;
        public string folder = "";
        public List<string> result = new List<string>();
        public long occurence_count = 0;

        public void Start()
        {
            t = new Thread(Search);
            if (result.Count != 0)
            {
                result.Clear();
            }
            Stop = false;
            t.Start();
        }

        private void Search()
        {
            Complete = false;
            occurence_count = 0;
            System.IO.DirectoryInfo di = new System.IO.DirectoryInfo(folder);
            WalkDirectoryTree(di);
            Complete = true;

            result.Add(string.Format("{0} occurence(s) removed.", occurence_count));
            MessageBox.Show("Рrocessing is complete", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        //рекурсивный обход каталогов
        private void WalkDirectoryTree(System.IO.DirectoryInfo root)
        {
            if (Stop)
            {
                return;
            }

            System.IO.FileInfo[] files = null;
            System.IO.DirectoryInfo[] subDirs = null;

            try
            {
                files = root.GetFiles("*.*");
            }
            catch (UnauthorizedAccessException e)
            {
                result.Add(string.Format("Access denied: {0}", e.Message));
            }
            catch (System.IO.DirectoryNotFoundException e)
            {
                result.Add(string.Format("Unable to read directory: {0}", e.Message));
            }

            if (files != null)
            {
                foreach (System.IO.FileInfo fi in files)
                {
                    foreach (string ext in extension)
                    {
                        if (fi.Extension == ext)
                        {
                            CheckFile(fi.FullName);
                        }
                    }
                }

                subDirs = root.GetDirectories();
                foreach (System.IO.DirectoryInfo dirInfo in subDirs)
                {
                    WalkDirectoryTree(dirInfo);
                }
            }
        }

        //удаление вредоносных фрагментов
        private void CheckFile(string file)
        {
            string text = System.IO.File.ReadAllText(file);
            string tmp_text = text;
            string node_text = string.Empty;
            List<string> delete_node = new List<string>();
            int posb = 0;
            int pose = 0;
            do
            {
                posb = tmp_text.IndexOf("<iframe");
                if (posb != -1)
                {
                    pose = tmp_text.Remove(0, posb).IndexOf("/>") + 2;
                    if (pose != -1)
                    {
                        node_text = tmp_text.Substring(posb, pose);
                        tmp_text = tmp_text.Remove(posb, pose);

                        if (node_text.IndexOf("virus") != -1)
                        {
                            delete_node.Add(node_text);
                        }   
                    }

                    else
                        break;
                }
            } while (posb != -1);

            for (int i = 0; i < delete_node.Count; i++)
            {
                text = text.Replace(delete_node[i], string.Empty);
            }

            if (delete_node.Count != 0)
            {
                try
                {
                    System.IO.File.WriteAllText(file, text);
                    occurence_count += delete_node.Count;
                }
                catch (UnauthorizedAccessException e)
                {
                    result.Add(string.Format("{0} - access denied: {1}", file, e.Message));
                }
            }

            result.Add(string.Format("{0} - {1} occurence(s) removed.", file, delete_node.Count));
        }
    }
}
