import io
import re

file_path = r'c:\capstoneII\Expense-tracker\lib\screens\transactions_screen.dart'

with io.open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace Row with Wrap for the category & date to definitely prevent UI overflows
old_row = '''                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 6,
                                                                  vertical: 2),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: catColor
                                                                .withOpacity(
                                                                    0.1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          child: Text(catName,
                                                              style: TextStyle(
                                                                  color:
                                                                      catColor,
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(
                                                          '• ',
                                                          style: TextStyle(
                                                              color: Colors.grey
                                                                  .shade600,
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ],
                                                    ),'''

new_wrap = '''                                                    Wrap(
                                                      spacing: 8,
                                                      runSpacing: 4,
                                                      crossAxisAlignment: WrapCrossAlignment.center,
                                                      children: [
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                          decoration: BoxDecoration(
                                                            color: catColor.withOpacity(0.1),
                                                            borderRadius: BorderRadius.circular(4),
                                                          ),
                                                          child: Text(catName,
                                                              style: TextStyle(color: catColor, fontSize: 10, fontWeight: FontWeight.bold)),
                                                        ),
                                                        Text(
                                                          '• ',
                                                          style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.w600),
                                                        ),
                                                      ],
                                                    ),'''

# Try regex replacement because formatting might be wildly different
# Just replace Row( children : [ Container( ... ) => Wrap( crossAxis ... )
pattern = re.compile(r'Row\(\s*children:\s*\[\s*Container\([^\]]+}\)\)\),\s*\),\s*const\s*SizedBox\(\s*width:\s*8\),\s*Text\(\s*\'• \\'[^\]]+\]\s*,\s*\)', re.MULTILINE)
# Since regex is risky with all the nested stuff, let's use replace
if old_row in content:
    content = content.replace(old_row, new_wrap)
else:
    print('Warning: Row not found, skipped Wrap conversion.')

with io.open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print('Done')
