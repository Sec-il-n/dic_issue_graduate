require 'rails_helper'

RSpec.describe Comment, type: :system do
  describe 'コメント機能' do
    describe 'コメント投稿機能' do
      context '提案詳細画面を表示した場合' do
        context '提案投稿者でない場合' do
          let!(:user) { create(:user, id: 1) }

          let!(:user_2) { create(:user, id: 2) }
          let!(:suggest) { create(:suggest, user_id: user_2.id) }
          before do
            suggest
            login_valid_user
          end
          it '提案にコメントを投稿できる' do
            fill_in_comment

            expect(page).to have_content('aaa')
          end
        end
        context'提案投稿者の場合' do
          let!(:user) { create(:user, id: 1) }
          let!(:suggests) { create_list(:suggest, 30) }
          before do
              login_valid_user
              suggests
          end
          it 'コメント投稿が失敗する' do
            fill_in_comment
            expect(page).to have_content("#{I18n.t('.dictionary.words.cannot comment')}")
          end
        end
      end
    end
    describe 'コメント表示機能' do
      context '提案詳細画面に遷移した場合'do
        context'提案に対するコメントが１件以上ある場合'do
          let!(:user) { create(:user) }
          let!(:user_2) { create(:user) }#Key (id)=(2) already exists.
          let!(:suggest) { create(:suggest, user_id: user_2.id) }
          let!(:comment) { create(:comment, suggest_id: suggest.id, user_id: user.id) }
          before do
            login(user)
          end
          it 'コメントが新着順で表示されている'do
            list = comment_list
            created_texts = sort_dcsc(list.last(2)).map(&:text)
            show_suggest
            shown_texts = all('.text').map(&:text)
            created_texts.each_with_index do |text, idx|
              expect(text).to eq(shown_texts[idx])
            end
          end
          it '最初の２件までが表示されている'do
            create_comment_list
            show_suggest
            expect(all('.comment').count).to eq(2)
          end
          context'「もっと見る」をクリックした場合'do
            it '残りのコメントが全て表示される'do
              create_comment_list
              show_suggest
              find('.more').click
              sleep 2.0
              expect(all('.comment').count).to eq(11)
            end
          end
        end
      end
    end
    describe 'コメント編集機能' do
      context '提案詳細画面を表示した場合' do
        let!(:user) { create(:user) }
        let!(:user_2) { create(:user, corporation_id: nil, proprietorship_id: 1) }
        let!(:suggest){ create(:suggest, user_id: user_2.id) }
        let!(:comment) { create(:comment, user_id: user.id, suggest_id: suggest.id) }

        context 'コメント投稿者の場合' do
          before do
            login(user)
            comment
          end
          it '編集リンクからコメントの編集ができる' do
            find(:xpath, '/html/body/div[2]/div[3]/div[1]/div[1]/strong/a').click

            execute_script('window.scrollBy(0,10000)')
            find(:xpath, '//*[@id="js-comment-1-edit-btn"]').click

            find(:xpath,'//*[@id="edit_text_box"]').fill_in with: 'abc'
            find(:xpath, '//*[@id="subumit_edit"]/input').click
            expect(page).to have_content('abc')
            expect(page).to have_content('コメントを編集しました')
          end
        end
        context 'コメント投稿者でない場合' do
          before do
            login(user_2)
            comment
          end
          it 'コメントの編集ができない' do
            first(:xpath, '/html/body/div[2]/div[3]/div[1]/div[1]/strong/a').click
            expect(page).not_to have_link('編集する')
          end
        end
      end
    end
  end
end
