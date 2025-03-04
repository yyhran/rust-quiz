import '../models/question.dart';

final sampleQuestions = [
  Question(
      id: 'q1',
      title: '指针基础',
      codeSnippet: '''
struct S {
    f: fn(),
}

impl S {
    fn f(&self) {
        print!("1");
    }
}

fn main() {
    let print2 = || print!("2");
    S { f: print2 }.f();
}''',
      correctIndex: 1,
      explanation: '指针p指向x的地址，*p解引用得到5',
      hint: ''),
  // 添加更多题目...
];
