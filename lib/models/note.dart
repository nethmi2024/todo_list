class Note {
  final int? id;
  final String title;
  final String content;
  final bool isPinned;

  Note({this.id, required this.title, required this.content, this.isPinned = false,});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'content': content,
      'isPinned': isPinned ? 1 : 0,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  Note copy({int? id, String? title, String? content, bool? isPinned}) => Note(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    isPinned: isPinned ?? this.isPinned,
  );

  factory Note.fromMap(Map<String, dynamic> map) => Note(
    id: map['id'],
    title: map['title'],
    content: map['content'],
    isPinned: map['isPinned'] == 1,
  );
}