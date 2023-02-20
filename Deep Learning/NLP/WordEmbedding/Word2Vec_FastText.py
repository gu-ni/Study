# %%
import pandas as pd
import matplotlib.pyplot as plt
import urllib.request
from gensim.models import Word2Vec
from gensim.models import FastText
from konlpy.tag import Okt
from tqdm import tqdm

# %%
## Word2Vec, FastText 한글
## 네이버 영화 리뷰 ###############################################################
urllib.request.urlretrieve("https://raw.githubusercontent.com/e9t/nsmc/master/ratings.txt", filename="ratings.txt")
train_data = pd.read_table('ratings.txt')

## 결측값 존재하는 행 제거
train_data = train_data.dropna(how = 'any') # Null 값이 존재하는 행 제거
## 정규 표현식을 통한 한글 외 문자 제거
train_data['document'] = train_data['document'].str.replace("[^ㄱ-ㅎㅏ-ㅣ가-힣 ]","")
## 불용어 정의
stopwords = ['의','가','이','은','들','는','좀','잘','걍','과','도','를','으로','자','에','와','한','하다']

##  형태소 분석기 OKT를 사용한 토큰화 작업 (다소 시간 소요)
okt = Okt()

tokenized_data = []
for sentence in tqdm(train_data['document']):
    tokenized_sentence = okt.morphs(sentence, stem=True) # 토큰화
    stopwords_removed_sentence = [word for word in tokenized_sentence if not word in stopwords] # 불용어 제거
    tokenized_data.append(stopwords_removed_sentence)

## 리뷰 길이 분포 확인
print('리뷰의 최대 길이 :',max(len(review) for review in tokenized_data))
print('리뷰의 평균 길이 :',sum(map(len, tokenized_data))/len(tokenized_data))

plt.hist([len(review) for review in tokenized_data], bins=50)
plt.xlabel('length of samples')
plt.ylabel('number of samples')
plt.show()

## Word2Vec으로 토큰화 된 네이버 영화 리뷰 데이터 학습
model = Word2Vec(sentences = tokenized_data,
                 vector_size = 100,
                 window = 5,
                 min_count = 5,
                 workers = 4,
                 sg = 0)
## 완성된 임베딩 매트릭스의 크기 확인
print(model.wv.vectors.shape) # 총 16,477개의 단어가 존재하며 각 단어는 100차원으로 구성

print(model.wv.most_similar("최민식")) # 최민식과 유사한 단어들
print(model.wv.most_similar("히어로")) # 히어로와 유사한 단어들

## FastText
model_fasttext = FastText(sentences = tokenized_data,
                 vector_size = 100,
                 window = 2,
                 min_count = 1,
                 workers = 4,
                 sg = 0)

## 완성된 임베딩 매트릭스의 크기 확인
print(model_fasttext.wv.vectors.shape) # 총 2631개의 단어가 존재하며 각 단어는 100차원으로 구성

print(model_fasttext.wv.most_similar("최민식")) # 최민식과 유사한 단어들
print(model_fasttext.wv.most_similar("히어로")) # 히어로와 유사한 단어들