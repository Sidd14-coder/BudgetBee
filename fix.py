import io

file_path = r'c:\capstoneII\Expense-tracker\lib\screens\transactions_screen.dart'

with io.open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix corrupt characters
content = content.replace('Ã¢â€šÂ¹', '₹')
content = content.replace('Ã¢â‚¬Â¢', '•')
content = content.replace('â‚¹', '₹')
content = content.replace('â€¢', '•')

# Fix the filtering logic
old_filter = '''    final displayMessages = selectedBank == null
        ? messages
        : messages.where((msg) {
            final bank = extractBankName(msg);
            return bank == selectedBank;
          }).toList();'''

new_filter = '''    final displayMessages = selectedBank == null
        ? messages
        : messages.where((msg) {
            final bank = msg.address;
            return bank == selectedBank;
          }).toList();'''

if old_filter in content:
    content = content.replace(old_filter, new_filter)
else:
    # Just in case whitespace is slightly different
    content = content.replace('final bank = extractBankName(msg);', 'final bank = msg.address;')

with io.open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print('Success')
