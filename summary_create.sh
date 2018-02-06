#!/bin/bash
# ʹ�÷���: ����Ŀ��Ŀ¼��ִ����������
# bash summary_create.sh
# ���ʹ��Windows, ����ʹ�� git bash ִ��
# v0.2 --------
# �ļ��������� [0-9][0-9]- ͨ���ļ��������½�������,����Ŀ¼
find `ls|egrep -v "_book|_other|node_modules"` -type f -name "*.md"|sed 's#README.md#00README.md#g'|sort|awk -F "/" '{if($NF!="00README.md") print $0"/" ;else print $0}' OFS="/"|sed  's#[^/]##g'|awk '{a=(length-1);while(a>0){printf "  ";a--}print "* "}' > /tmp/summary_1
find `ls|egrep -v "_book|_other|node_modules"` -type f -name "*.md"|sed "s#README.md#00README.md#g"|sort|awk -F "[./]" '{if($(NF-1) != "00README") print $(NF-1)"]("$0")" ;else print $(NF-2)"]("$0")"}' > /tmp/summary_2
paste -d "[" /tmp/summary_1 /tmp/summary_2 > tmp_SUMMARY.md
sed 's#00README.md#README.md#g' tmp_SUMMARY.md|grep -v "SUMMARY](SUMMARY"|awk  '{if(NR==1)print "# Sumarry\n\n* [Introduction](README.md)\n* [SUMMARY](SUMMARY.md)";else print $0}' > SUMMARY.md && mv tmp_SUMMARY.md /tmp
# ����Mac��,sed -i��������Ҫָ�������ļ�(��Ȼ����ʹ�� -i "" ����һ�����ַ�,������,��������д����Linux�ϻᱨ��),�������ﲻʹ��-i����
# ˵�� -i ""��Mac�¿���ʹ��, -i"" ��Linux�¿���ʹ��,��������������ʹ��
#|sed 's#[0-9][0-9]-##g' ����ȥ������,����gitbook���ɾ�̬�ļ���ʱ��,md�ļ�Ҳû������

# �ļ������������ʱ���ʹ������01- , 02-,��ͷ, ��Ŀ¼��ʾ��ʱ��ɾ���ⲿ�� 
# ����Ŀ¼��ʾ, ��Mac ��ʹ����Ҫ��������
sed -ri 's#(\S+* \[)[0-9]+-(.*$)#\1\2#g' SUMMARY.md