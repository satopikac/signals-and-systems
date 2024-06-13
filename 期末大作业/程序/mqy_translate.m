function note_num = mqy_translate(f)  
    %使用 220 Hz 作为基准  A3
    note_offset = 12 * log2(f / 220); % 计算对数比并乘以 12  
    note_num = mod(round(note_offset), 12); % 转换为音符编号  
    if note_num < 0 % 确保音符编号在 0 到 11 之间  
        note_num = note_num + 12;  
    end  
end