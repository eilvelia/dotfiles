;; example https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/master/queries/haskell/textobjects.scm

;; TODO: Finish the text objects

(let_binding
  pattern: (value_name)
  (parameter)) @function.outer

(parameter) @parameter.inner
(parameter) @parameter.outer

(let_binding
  pattern: (value_name)
  body: [(fun_expression) (function_expression)]) @function.outer

(comment) @comment.outer
