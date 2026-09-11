-- 크라우드소싱 제보 데이터 테이블
create table crowd_entries (
  id bigint generated always as identity primary key,
  volume integer not null check (volume between 200 and 1200),
  material text not null check (material in ('steel','alu','pottery')),
  temp integer not null check (temp between 0 and 60),
  seconds numeric not null check (seconds between 10 and 3600),
  submitted_at timestamptz not null default now()
);

-- 보안 규칙 활성화
alter table crowd_entries enable row level security;

-- 누구나(로그인 없이) 새 데이터를 넣을 수 있게 허용
create policy "Allow public insert"
  on crowd_entries
  for insert
  to anon
  with check (true);

-- 누구나 읽어서 통계 낼 수 있게 허용
create policy "Allow public read"
  on crowd_entries
  for select
  to anon
  using (true);
