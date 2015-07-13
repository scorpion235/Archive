using System.Windows.Forms;

namespace WorkOnProjects.Classes
{
  public class Common
  {
    public static DialogResult MsgBox(string msg)
    {
      return MessageBox.Show(msg, "Информация", MessageBoxButtons.OK, MessageBoxIcon.Information);
    }

    public static DialogResult WarningBox(string msg)
    {
      return MessageBox.Show(msg, "Предупреждение", MessageBoxButtons.OK, MessageBoxIcon.Warning);
    }

    public static DialogResult ErrorBox(string msg)
    {
      return MessageBox.Show(msg, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error);
    }

    public static DialogResult YesNoBox(string msg)
    {
      return MessageBox.Show(msg, "Ошибка", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
    }
  }
}
