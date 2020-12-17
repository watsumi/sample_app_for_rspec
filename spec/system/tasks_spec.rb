require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task, user: user) }

  describe 'ログイン前' do
    describe 'ページ遷移' do
      context '新規登録画面に遷移' do
        it '新規登録画面に遷移できない' do
          visit new_task_path
          expect(page).to have_content('Login required')
          expect(current_path).to eq login_path
        end
      end

      context '編集画面に遷移' do
        it 'タスク編集画面に遷移できない' do
          visit edit_task_path(task)
          expect(page).to have_content('Login required')
          expect(current_path).to eq login_path
        end
      end

      context 'タスク一覧画面に遷移' do
        it '一覧画面に遷移できる' do
          visit tasks_path
          expect(page).to have_content('Tasks')
          expect(page).to have_content('Title')
          expect(page).to have_content('Content')
          expect(page).to have_content('Status')
          expect(page).to have_content('Deadline')
          expect(current_path).to eq tasks_path
        end
      end

      context 'タスク詳細画面に遷移' do
        it '詳細画面に遷移できる' do
          visit task_path(task)
          expect(page).to have_content task.title
          expect(current_path).to eq task_path(task)
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'タスクの新規作成' do
      context 'フォームの入力値が正常' do
        it 'タスクの新規作成に成功する' do
          visit new_task_path
          fill_in 'Title', with: 'title_test'
          fill_in 'Content', with: 'content_test'
          select 'todo', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2020, 12, 17, 22, 50)
          click_button 'Create Task'
          expect(page).to have_content('Task was successfully created.')
          expect(page).to have_content('Title: title_test')
          expect(page).to have_content('Content: content_test')
          expect(page).to have_content('Status: todo')
          expect(page).to have_content('Deadline: 2020/12/17 22:50')
          expect(current_path).to eq '/tasks/1'
        end
      end

      context 'タイトルが未入力' do
        it 'タスクの作成に失敗する' do
          visit new_task_path
          fill_in 'Title', with: ''
          fill_in 'Content', with: 'content_test'
          select 'todo', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2020, 12, 17, 22, 50)
          click_button 'Create Task'
          expect(page).to have_content('1 error prohibited this task from being saved:')
          expect(page).to have_content("Title can't be blank")
          expect(page).to have_field 'Title', with: ''
          expect(page).to have_field 'Content', with: 'content_test'
          expect(page).to have_field 'Status', with: 'todo'
          expect(page).to have_field 'Deadline', with: "2020-12-17T22:50:00"
          expect(current_path).to eq tasks_path
        end
      end
      
      context 'タイトルが重複' do
        it 'タスクの作成に失敗する' do
          visit new_task_path
          fill_in 'Title', with: task.title
          fill_in 'Content', with: 'content_test'
          select 'todo', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2020, 12, 17, 22, 50)
          click_button 'Create Task'
          expect(page).to have_content('1 error prohibited this task from being saved:')
          expect(page).to have_content("Title has already been taken")
          expect(page).to have_field 'Title', with: task.title
          expect(page).to have_field 'Content', with: 'content_test'
          expect(page).to have_field 'Status', with: 'todo'
          expect(page).to have_field 'Deadline', with: "2020-12-17T22:50:00"
          expect(current_path).to eq tasks_path
        end
      end
    end

    describe 'タスクの編集' do
      let!(:task) { create(:task, user: user) }
      let!(:other_task) { create(:task, user: user) }
      before { visit edit_task_path(task) }

      context 'フォームの入力値が正常' do
        it 'タスクの編集に成功する' do
          fill_in 'Title', with: 'title_test'
          select 'todo', from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content('Task was successfully updated.')
          expect(page).to have_content('Title: title_test')
          expect(page).to have_content('Status: todo')
          expect(current_path).to eq task_path(task)
        end
      end

      context 'タイトルが未入力' do
        it 'タスクの編集に失敗する' do
          fill_in 'Title', with: ''
          select 'todo', from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content('1 error prohibited this task from being saved:')
          expect(page).to have_content("Title can't be blank")
          expect(page).to have_field 'Title', with: ''
          expect(page).to have_field 'Status', with: 'todo'
          expect(current_path).to eq task_path(task)
        end
      end

      context 'タイトルが重複' do
        it 'タスクの編集に失敗する' do
          fill_in 'Title', with: other_task.title
          select 'todo', from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content('1 error prohibited this task from being saved:')
          expect(page).to have_content("Title has already been taken")
          expect(page).to have_field 'Title', with: other_task.title
          expect(page).to have_field 'Status', with: 'todo'
          expect(current_path).to eq task_path(task)
        end
      end
    end

    describe 'タスクの削除' do
      let!(:task) { create(:task, user: user) }

      it 'タスクの削除に成功する' do
        visit tasks_path
        click_on "Destroy"
        expect(page.accept_confirm).to eq 'Are you sure?'
        expect(current_path).to eq tasks_path
        expect(page).to have_content("Task was successfully destroyed")
        expect(page).to_not have_content task.title
      end
    end
  end
end
