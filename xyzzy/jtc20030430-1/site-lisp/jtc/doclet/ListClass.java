import com.sun.javadoc.*;

public class ListClass {
  public static boolean start(RootDoc root) {
    ClassDoc[] cld = root.classes();

    for (int i = 0; i < cld.length; ++i) {
      String m = null;
      String u1 = null;
      String u2 = null;
      String s1 = null;
      String s2 = null;

      // �N���X��
      System.out.println((char)2 + cld[i].typeName());

      // �X�[�p�[�N���X��
      if (cld[i].superclass() != null) {
        System.out.println((char)6 + "class " + cld[i].typeName()
                           + " extends " + cld[i].superclass().typeName() + ";");
        System.out.println((char)7 + cld[i].superclass().typeName());
      } else {
        System.out.println((char)6 + "class " + cld[i].typeName() + ";");
        System.out.println((char)7 + "");
      }

      // url
      s1 = cld[i].qualifiedTypeName();
      s2 = cld[i].name();
      u1 = s1.substring(0, s1.lastIndexOf(s2)).replace('.', '/');
      u2 = u1 + s2 + ".html";
      System.out.println((char)8 + u2);

      // qualifiedTypeName
      System.out.println((char)11 + s1);

      // ------------------------------------
      // �R���X�g���N�^��񖈂̏���
      ConstructorDoc[] cd = cld[i].constructors();
      if (0 < cd.length) {

        // ���O�̏o��
        System.out.println((char)3 + "c");
        System.out.println((char)4 + "");
        System.out.println((char)5 + cd[0].name());
        System.out.println((char)8 + u2);
        System.out.print((char)6);

        // �V�O�l�`���̍쐬
        for (int j = 0; j < cd.length; j ++) {

          Parameter[] pm = cd[j].parameters();
          System.out.print(cd[j].name() + "(");
          for (int k = 0; k < pm.length; k ++) {
            if (k != 0) {
              System.out.print(", ");
            }
            System.out.print(pm[k].type().typeName() + pm[k].type().dimension() + " " + pm[k].name());
          }
          System.out.print(")");

          // ��O���̍쐬
          Type[] tp = cd[j].thrownExceptions();
          for (int k = 0; k < tp.length; k ++) {
            if (k == 0) {
              System.out.print(" throws ");
            } else {
              System.out.print(", ");
            }
            System.out.print(tp[k].typeName());
          }
          System.out.println(";");
        }
      }
      // �R���X�g���N�^��񖈂̏����I��
      // ------------------------------------

      // ------------------------------------
      // �����N���X���̏���
      ClassDoc[] icd = cld[i].innerClasses();
      for (int j = 0; j < icd.length; j ++) {

        String s = icd[j].typeName();
        int idx = s.lastIndexOf(".");

        if (0 <= idx) {
          System.out.println((char)3 + "l");
          System.out.println((char)4 + icd[j].typeName());
          System.out.println((char)5 + s.substring(idx + 1));
          System.out.println((char)8 + u1 + icd[j].name() + ".html");
          System.out.println((char)6 + "inner class " + icd[j].typeName() + ";");
        }
      }      
      // �����N���X���̏����I��
      // ------------------------------------
      
      // ------------------------------------
      // �t�B�[���h��񖈂̏���
      FieldDoc[] fd = cld[i].fields();
      for (int j = 0; j < fd.length; j ++) {

        System.out.println((char)3 + "f");
        System.out.println((char)4 + fd[j].type().typeName());
        System.out.println((char)5 + fd[j].name());
        System.out.println((char)8 + u2 + "#" + fd[j].name());
        System.out.println((char)6 + fd[j].type().typeName() + " " + fd[j].name() + ";");
      }
      // �t�B�[���h��񖈂̏����I��
      // ------------------------------------

      // ------------------------------------
      // ���\�b�h��񖈂̏���
      MethodDoc[] md = cld[i].methods();
      for (int j = 0; j < md.length; j ++) {

        // ���O�^�^���̏o��
        if (md[j].name().equals(m) == false) {
          m = md[j].name();
          System.out.println((char)3 + "m");
          System.out.println((char)4 + md[j].returnType().typeName());
          System.out.println((char)5 + md[j].name());
          // URL��NAME�����̍쐬
          Parameter[] pm = md[j].parameters();
          System.out.print((char)8 + u2 + "#" + md[j].name() + "(");
          for (int k = 0; k < pm.length; k ++) {
            if (k != 0) {
              System.out.print(", ");
            }
            System.out.print(pm[k].type().qualifiedTypeName() + pm[k].type().dimension());
          }
          System.out.println(")");
          System.out.print((char)6);
        }

        // �V�O�l�`���̍쐬
        Parameter[] pm = md[j].parameters();
        System.out.print(md[j].returnType().typeName() + md[j].returnType().dimension() +
                         " " + md[j].name() + "(");
        for (int k = 0; k < pm.length; k ++) {
          if (k != 0) {
            System.out.print(", ");
          }
          System.out.print(pm[k].type().typeName() + pm[k].type().dimension() + 
                           " " + pm[k].name());
        }
        System.out.print(")");

        // ��O���̍쐬
        Type[] tp = md[j].thrownExceptions();
        for (int k = 0; k < tp.length; k ++) {
          if (k == 0) {
            System.out.print(" throws ");
          } else {
            System.out.print(", ");
          }
          System.out.print(tp[k].typeName());
        }
        System.out.println(";");
      }
      // ���\�b�h��񖈂̏����I��
      // ------------------------------------
    }
    System.out.println((char)12);
    
    return true;
  }
}
