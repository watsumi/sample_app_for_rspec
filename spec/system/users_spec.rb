require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          new_user = build(:user)
          visit sign_up_path
          fill_in 'Email', with: new_user.email
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'

          expect(page).to have_content "User was successfully created"
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit sign_up_path
          fill_in 'Email', with: ""
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'

          expect(page).to have_content "1 error prohibited this user from being saved"
          expect(page).to have_content("Email can't be blank")
          expect(page).to have_field 'Email', with: ""
          expect(page).to have_field 'Password', with: ""
          expect(page).to have_field 'Password confirmation', with: ""
        end
      end
      context '登録済のメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          exist_user = create(:user)
          visit sign_up_path
          fill_in 'Email', with: exist_user.email
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'

          expect(page).to have_content "1 error prohibited this user from being saved"
          expect(page).to have_content("Email has already been taken")
          expect(page).to have_field 'Email', with: exist_user.email
          expect(page).to have_field 'Password', with: ""
          expect(page).to have_field 'Password confirmation', with: ""
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          visit users_path(user)
          expect(page).to have_content("Login required")
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          visit edit_user_path(user)
          fill_in 'Email', with: 'update@example.com'
          fill_in 'Password', with: 'update_password'
          fill_in 'Password confirmation', with: 'update_password'
          click_button 'Update'
          expect(current_path).to eq user_path(user)
          expect(page).to have_content('User was successfully updated.')
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_path(user)
          fill_in 'Email', with: nil
          fill_in 'Password', with: 'update_password'
          fill_in 'Password confirmation', with: 'update_password'
          click_button 'Update'
          expect(current_path).to eq user_path(user)
          expect(page).to have_content('1 error prohibited this user from being saved:')
          expect(page).to have_content("Email can't be blank")
          expect(page).to have_field 'Email', with: ""
          expect(page).to have_field 'Password', with: ""
          expect(page).to have_field 'Password confirmation', with: ""
        end
      end
      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_path(user)
          fill_in 'Email', with: other_user.email
          fill_in 'Password', with: 'update_password'
          fill_in 'Password confirmation', with: 'update_password'
          click_button 'Update'
          expect(current_path).to eq user_path(user)
          expect(page).to have_content('1 error prohibited this user from being saved:')
          expect(page).to have_content("Email has already been taken")
          expect(page).to have_field 'Email', with: other_user.email
          expect(page).to have_field 'Password', with: ""
          expect(page).to have_field 'Password confirmation', with: ""         
        end
      end
      context '他ユーザーの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          visit edit_user_path(other_user)
          expect(current_path).to eq user_path(user)
          expect(page).to have_content("Forbidden access.")
        end
      end
    end

    describe 'マイページ' do
      context 'タスクを作成' do 
        it '新規作成したタスクが表示される' do
          create(:task, title: 'test_title', status: :doing, user: user)
          visit user_path(user)
          expect(page).to have_content("You have 1 task.")
          expect(page).to have_content("test_title")
          expect(page).to have_content("doing")
        end
      end
    end
  end
end
