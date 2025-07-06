List<String> extractInstructionsList(String raw) {
  final lines = raw.split('\n');

  // Find the start of instructions
  final startIndex = lines.indexWhere(
    (line) => line.toLowerCase().contains('instructions:'),
  );
  if (startIndex == -1) return [];

  final instructions = <String>[];

  for (int i = startIndex + 1; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty) continue;

    // Stop if a new section starts (optional)
    if (line.toLowerCase().startsWith('**') &&
        !RegExp(r'^\d+\.').hasMatch(line)) {
      break;
    }

    // Clean **bold** markers
    final cleaned = line.replaceAllMapped(
      RegExp(r'\*\*(.*?)\*\*'),
      (match) => match.group(1) ?? '',
    );

    // Match steps like "1. Do something"
    if (RegExp(r'^\d+\.\s').hasMatch(cleaned)) {
      instructions.add(cleaned);
    } else if (instructions.isNotEmpty) {
      // Append to previous step if multiline
      instructions[instructions.length - 1] += ' $cleaned';
    }
  }

  return instructions;
}
