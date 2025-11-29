# frozen_string_literal: true

# SimpleForm configuration for Tailwind CSS
# These defaults are customized for Tailwind CSS styling
# See https://github.com/heartcombo/simple_form for more information

# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  # REMOVE Simple Form's automatic classes
  config.generate_additional_classes_for = []

  # Default class for buttons
  config.button_class = 'btn btn-sm btn-primary'

  # Define the default class of the input wrapper of the boolean input.
  config.boolean_label_class = 'inline-flex items-center'

  # How the label text should be generated altogether with the required text.
  config.label_text = lambda { |label, required, explicit_label| "#{label} #{required}" }

  # Define the way to render check boxes / radio buttons with labels.
  config.boolean_style = :inline

  # You can wrap each item in a collection of radio/check boxes with a tag
  config.item_wrapper_tag = :div

  # Defines if the default input wrapper class should be included in radio collection wrappers.
  config.include_default_input_wrapper_class = false

  # CSS class to add for error notification helper.
  config.error_notification_class = 'rounded-md bg-red-50 p-4 text-sm text-red-800'

  # Method used to tidy up errors. Specify any Rails Array method.
  # :first lists the first message for each field.
  # :to_sentence to list all errors for each field.
  config.error_method = :to_sentence

  # add validation classes to `input_field`
  config.input_field_error_class = 'border-red-500 focus:border-red-500 focus:ring-red-500'
  config.input_field_valid_class = 'border-green-500 focus:border-green-500 focus:ring-green-500'


  # vertical forms
  #
  # vertical default_wrapper
  config.wrappers :vertical_form, class: 'mb-6' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'block text-sm font-medium text-gray-700 mb-1'
    b.use :input, class: 'input w-full'
    b.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
  end

  config.wrappers :vertical_text_area, class: 'mb-6' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'block text-sm font-medium text-gray-700 mb-1'
    b.use :input, class: 'textarea w-full'
    b.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
  end

  # vertical input for boolean
  config.wrappers :vertical_boolean, tag: 'fieldset', class: 'mb-6' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper :form_check_wrapper, class: 'flex items-center' do |bb|
      bb.use :input, class: 'h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500', error_class: 'border-red-500 focus:ring-red-500', valid_class: 'border-green-500 focus:ring-green-500'
      bb.use :label, class: 'ml-3 block text-sm text-gray-700'
      bb.use :full_error, wrap_with: { class: 'mt-2 text-sm text-red-600' }
      bb.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
    end
  end

  # vertical input for radio buttons and check boxes
  config.wrappers :vertical_checkbox, item_wrapper_class: 'flex items-center mb-3', item_label_class: 'ml-3 block text-sm text-gray-700', tag: 'fieldset', class: 'mb-6' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper :legend_tag, tag: 'legend', class: 'text-base font-medium text-gray-900 mb-3' do |ba|
      ba.use :label_text
    end
    b.use :input, class: 'checkbox', error_class: 'border-red-500 focus:ring-red-500', valid_class: 'border-green-500 focus:ring-green-500'
    b.use :full_error, wrap_with: { class: 'mt-2 text-sm text-red-600 block' }
    b.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
  end

  config.wrappers :vertical_radio, item_wrapper_class: 'flex items-center mb-3', item_label_class: 'ml-3 block text-sm text-gray-700', tag: 'fieldset', class: 'mb-6' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper :legend_tag, tag: 'legend', class: 'text-base font-medium text-gray-900 mb-3' do |ba|
      ba.use :label_text
    end
    b.use :input, class: 'radio', error_class: 'border-red-500 focus:ring-red-500', valid_class: 'border-green-500 focus:ring-green-500'
    b.use :full_error, wrap_with: { class: 'mt-2 text-sm text-red-600 block' }
    b.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
  end

  # vertical input for inline radio buttons and check boxes
  config.wrappers :vertical_collection_inline, item_wrapper_class: 'inline-flex items-center mr-6', item_label_class: 'ml-3 block text-sm text-gray-700', tag: 'fieldset', class: 'mb-6' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper :legend_tag, tag: 'legend', class: 'text-base font-medium text-gray-900 mb-3' do |ba|
      ba.use :label_text
    end
    b.use :input, class: 'h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500', error_class: 'border-red-500 focus:ring-red-500', valid_class: 'border-green-500 focus:ring-green-500'
    b.use :full_error, wrap_with: { class: 'mt-2 text-sm text-red-600 block' }
    b.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
  end

  # vertical file input
  config.wrappers :vertical_file, class: 'mb-6' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :readonly
    b.use :label, class: 'block text-sm font-medium text-gray-700 mb-1'
    b.use :input, class: 'block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100', error_class: 'border-red-500', valid_class: 'border-green-500'
    b.use :full_error, wrap_with: { class: 'mt-2 text-sm text-red-600' }
    b.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
  end

  # vertical select input
  config.wrappers :vertical_select, class: 'mb-6' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'block text-sm font-medium text-gray-700 mb-1'
    b.use :input, class: 'select w-full', error_class: 'border-red-500', valid_class: 'border-green-500'
    b.use :full_error, wrap_with: { class: 'mt-2 text-sm text-red-600' }
    b.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
  end

  # vertical multi select
  config.wrappers :vertical_multi_select, class: 'mb-6' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'block text-sm font-medium text-gray-700 mb-1'
    b.wrapper class: 'flex flex-row justify-between items-center' do |ba|
      ba.use :input, class: 'block w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 bg-white', error_class: 'border-red-500 focus:ring-red-500 focus:border-red-500', valid_class: 'border-green-500 focus:ring-green-500 focus:border-green-500'
    end
    b.use :full_error, wrap_with: { class: 'mt-2 text-sm text-red-600 block' }
    b.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
  end

  # vertical datetime (native html5 input)
  config.wrappers :vertical_datetime, class: 'mb-6' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :readonly
    b.use :label, class: 'block text-sm font-medium text-gray-700 mb-1'
    b.use :input, class: 'block rounded-md border px-3 py-2 w-full border-gray-300 focus:outline-blue-600', error_class: 'border-red-400 focus:outline-red-600', valid_class: 'border-gray-400 focus:outline-blue-600'
    b.use :full_error, wrap_with: { class: 'mt-2 text-sm text-red-600' }
    b.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
  end

  # vertical range input
  config.wrappers :vertical_range, class: 'mb-6' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :readonly
    b.optional :step
    b.use :label, class: 'block text-sm font-medium text-gray-700 mb-1'
    b.use :input, class: 'w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-blue-600', error_class: 'accent-red-600', valid_class: 'accent-green-600'
    b.use :full_error, wrap_with: { class: 'mt-2 text-sm text-red-600' }
    b.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
  end


  # horizontal forms
  #
  # horizontal default_wrapper
  config.wrappers :horizontal_form, class: 'mb-6 grid grid-cols-12 gap-4 items-start' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'col-span-3 text-sm font-medium text-gray-700 pt-2'
    b.wrapper :grid_wrapper, class: 'col-span-9' do |ba|
      ba.use :input, class: 'input w-full', error_class: 'border-red-500 focus:ring-red-500 focus:border-red-500', valid_class: 'border-green-500 focus:ring-green-500 focus:border-green-500'
      ba.use :full_error, wrap_with: { class: 'mt-2 text-sm text-red-600' }
      ba.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
    end
  end

  # horizontal input for boolean
  config.wrappers :horizontal_boolean, class: 'mb-6 grid grid-cols-12 gap-4' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper :grid_wrapper, class: 'col-span-9 col-start-4' do |wr|
      wr.wrapper :form_check_wrapper, class: 'flex items-center' do |bb|
        bb.use :input, class: 'h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500', error_class: 'border-red-500 focus:ring-red-500', valid_class: 'border-green-500 focus:ring-green-500'
        bb.use :label, class: 'ml-3 block text-sm text-gray-700'
        bb.use :full_error, wrap_with: { class: 'mt-2 text-sm text-red-600' }
        bb.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
      end
    end
  end

  # horizontal input for radio buttons and check boxes
  config.wrappers :horizontal_collection, item_wrapper_class: 'flex items-center mb-3', item_label_class: 'ml-3 block text-sm text-gray-700', class: 'mb-6 grid grid-cols-12 gap-4' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'col-span-3 text-sm font-medium text-gray-700 pt-2'
    b.wrapper :grid_wrapper, class: 'col-span-9' do |ba|
      ba.use :input, class: 'h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500', error_class: 'border-red-500 focus:ring-red-500', valid_class: 'border-green-500 focus:ring-green-500'
      ba.use :full_error, wrap_with: { class: 'mt-2 text-sm text-red-600 block' }
      ba.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
    end
  end

  # horizontal input for inline radio buttons and check boxes
  config.wrappers :horizontal_collection_inline, item_wrapper_class: 'inline-flex items-center mr-6', item_label_class: 'ml-3 block text-sm text-gray-700', class: 'mb-6 grid grid-cols-12 gap-4' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'col-span-3 text-sm font-medium text-gray-700 pt-2'
    b.wrapper :grid_wrapper, class: 'col-span-9' do |ba|
      ba.use :input, class: 'h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500', error_class: 'border-red-500 focus:ring-red-500', valid_class: 'border-green-500 focus:ring-green-500'
      ba.use :full_error, wrap_with: { class: 'mt-2 text-sm text-red-600 block' }
      ba.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
    end
  end

  # horizontal file input
  config.wrappers :horizontal_file, class: 'mb-6 grid grid-cols-12 gap-4 items-start' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :readonly
    b.use :label, class: 'col-span-3 text-sm font-medium text-gray-700 pt-2'
    b.wrapper :grid_wrapper, class: 'col-span-9' do |ba|
      ba.use :input, class: 'block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100', error_class: 'border-red-500', valid_class: 'border-green-500'
      ba.use :full_error, wrap_with: { class: 'mt-2 text-sm text-red-600' }
      ba.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
    end
  end

  # horizontal select input
  config.wrappers :horizontal_select, class: 'mb-6 grid grid-cols-12 gap-4 items-start' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'col-span-3 text-sm font-medium text-gray-700 pt-2'
    b.wrapper :grid_wrapper, class: 'col-span-9' do |ba|
      ba.use :input, class: 'block w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 bg-white', error_class: 'border-red-500 focus:ring-red-500 focus:border-red-500', valid_class: 'border-green-500 focus:ring-green-500 focus:border-green-500'
      ba.use :full_error, wrap_with: { class: 'mt-2 text-sm text-red-600' }
      ba.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
    end
  end

  # horizontal multi select
  config.wrappers :horizontal_multi_select, class: 'mb-6 grid grid-cols-12 gap-4 items-start' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'col-span-3 text-sm font-medium text-gray-700 pt-2'
    b.wrapper :grid_wrapper, class: 'col-span-9' do |ba|
      ba.wrapper class: 'flex flex-row justify-between items-center' do |bb|
        bb.use :input, class: 'block w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 bg-white', error_class: 'border-red-500 focus:ring-red-500 focus:border-red-500', valid_class: 'border-green-500 focus:ring-green-500 focus:border-green-500'
      end
      ba.use :full_error, wrap_with: { class: 'mt-2 text-sm text-red-600 block' }
      ba.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
    end
  end

  # horizontal range input
  config.wrappers :horizontal_range, class: 'mb-6 grid grid-cols-12 gap-4 items-start' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :readonly
    b.optional :step
    b.use :label, class: 'col-span-3 text-sm font-medium text-gray-700 pt-2'
    b.wrapper :grid_wrapper, class: 'col-span-9' do |ba|
      ba.use :input, class: 'w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-blue-600', error_class: 'accent-red-600', valid_class: 'accent-green-600'
      ba.use :full_error, wrap_with: { class: 'mt-2 text-sm text-red-600' }
      ba.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
    end
  end


  # inline forms
  #
  # inline default_wrapper
  config.wrappers :inline_form, class: 'col-12' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'sr-only'

    b.use :input, class: 'block w-full px-3 py-2 border border-gray-300 rounded-md placeholder-gray-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500', error_class: 'border-red-500 focus:ring-red-500 focus:border-red-500', valid_class: 'border-green-500 focus:ring-green-500 focus:border-green-500'
    b.use :error, wrap_with: { class: 'mt-2 text-sm text-red-600' }
    b.optional :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
  end

  # inline input for boolean
  config.wrappers :inline_boolean, class: 'col-12' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper :form_check_wrapper, class: 'flex items-center' do |bb|
      bb.use :input, class: 'h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500', error_class: 'border-red-500 focus:ring-red-500', valid_class: 'border-green-500 focus:ring-green-500'
      bb.use :label, class: 'ml-3 block text-sm text-gray-700'
      bb.use :error, wrap_with: { class: 'mt-2 text-sm text-red-600' }
      bb.optional :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
    end
  end


  # Tailwind custom toggle switch for boolean
  config.wrappers :custom_boolean_switch, class: 'mb-6' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper :form_check_wrapper, tag: 'div', class: 'flex items-center' do |bb|
      bb.use :input, class: 'relative inline-flex h-6 w-11 items-center rounded-full bg-gray-300 transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 cursor-pointer [&:checked]:bg-blue-600', error_class: '[&:checked]:bg-red-600', valid_class: '[&:checked]:bg-green-600'
      bb.use :label, class: 'ml-3 text-sm font-medium text-gray-700'
      bb.use :full_error, wrap_with: { tag: 'div', class: 'mt-2 text-sm text-red-600' }
      bb.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
    end
  end


  # Input Group - custom component
  config.wrappers :input_group, class: 'mb-6' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'block text-sm font-medium text-gray-700 mb-1'
    b.wrapper :input_group_tag, class: 'flex rounded-md' do |ba|
      ba.optional :prepend
      ba.use :input, class: 'relative flex flex-1 items-stretch flex-shrink-0 border border-gray-300 placeholder-gray-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500 px-3 py-2', error_class: 'border-red-500 focus:ring-red-500 focus:border-red-500', valid_class: 'border-green-500 focus:ring-green-500 focus:border-green-500'
      ba.optional :append
      ba.use :full_error, wrap_with: { class: 'mt-2 text-sm text-red-600' }
    end
    b.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
  end


  # Floating Labels form
  #
  # floating labels default_wrapper
  config.wrappers :floating_labels_form, class: 'relative mb-6' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :input, class: 'block px-2.5 pb-2.5 pt-4 w-full text-sm text-gray-900 bg-transparent rounded-lg border-1 border-gray-300 appearance-none focus:outline-none focus:ring-0 focus:border-blue-600 peer placeholder-transparent', error_class: 'border-red-500 focus:border-red-500', valid_class: 'border-green-500 focus:border-green-500'
    b.use :label, class: 'absolute text-sm text-gray-500 duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4'
    b.use :full_error, wrap_with: { class: 'mt-2 text-sm text-red-600' }
    b.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
  end

  # floating labels select
  config.wrappers :floating_labels_select, class: 'relative mb-6' do |b|
    b.use :html5
    b.optional :readonly
    b.use :input, class: 'block px-2.5 pb-2.5 pt-4 w-full text-sm text-gray-900 bg-transparent rounded-lg border-1 border-gray-300 appearance-none focus:outline-none focus:ring-0 focus:border-blue-600 peer', error_class: 'border-red-500 focus:border-red-500', valid_class: 'border-green-500 focus:border-green-500'
    b.use :label, class: 'absolute text-sm text-gray-500 duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4'
    b.use :full_error, wrap_with: { class: 'mt-2 text-sm text-red-600' }
    b.use :hint, wrap_with: { class: 'mt-2 text-sm text-gray-500' }
  end


  # The default wrapper to be used by the FormBuilder.
  config.default_wrapper = :vertical_form

  # Custom wrappers for input types. This should be a hash containing an input
  # type as key and the wrapper that will be used for all inputs with specified type.
  config.wrapper_mappings = {
    text_area:     :vertical_text_area,
    boolean:       :vertical_boolean,
    check_boxes:   :vertical_checkbox,
    date:          :vertical_datetime,
    datetime:      :vertical_datetime,
    file:          :vertical_file,
    radio_buttons: :vertical_radio,
    range:         :vertical_range,
    time:          :vertical_datetime,
    select:        :vertical_select
  }
end