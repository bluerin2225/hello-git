function word_test()
word = actxserver('Word.Application');
word.DisplayAlerts = 0;
doc = word.Documents.Open('C:\Users\tomonori\Desktop\新規 Microsoft Word Document.docx');

sectionNum = doc.Sections.Count;
for sectionIndex=1:sectionNum
    headers = doc.Sections.Item(sectionIndex).Headers;
    headerNum = headers.Count;
    for headerIndex=1:headerNum
        text = headers.Item(headerIndex).Range.Text;
        convertedText = [];
        
        s = strsplit(text, char(9));
        sLen = length(s);
        
        for i=1:sLen
            t = s{i};
            m = regexp(t, '.*?-a.*?-.*?-.*?', 'match');
            if isempty(m)
                if i == 1
                    convertedText = t;
                else
                    convertedText = [convertedText char(9) t];
                end
                continue;
            end

            mLen = length(m);
            for j=1:mLen
                temp = m{j};
                t = strrep(t, temp, 'converted!');
            end
            
            if i == 1
                convertedText = t;
            else
                convertedText = [convertedText char(9) t];
            end
        end
        
        headers.Item(headerIndex).Range.Text = text;
    end
end

doc.Save();
doc.Close();
doc.release();

word.Quit();
word.release();
end
