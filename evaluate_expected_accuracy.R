#
# Copyright 2020 Simone Maestri. All rights reserved.
# Simone Maestri <simone.maestri@univr.it>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

Evaluate_expected_accuracy <- function(acc_by_pos) {
 #acc_by_pos <- c(99.9, 96.3, 95, 98.2, 100, 100, 100, 100, 100, 100, 100, 98.9, 100, 100, 100, 100, 99.9, 100)
 #acc_by_pos <- c(77.3, 96.3)
 
# if (max(acc_by_pos) > 1) {
#   acc_by_pos_rescaled <- acc_by_pos/100
# } else {
#   acc_by_pos_rescaled <- acc_by_pos
# }

# acc_curr_pos <- vector(length = length(acc_by_pos_rescaled))
# n <- 10
# for (i in 1:length(acc_by_pos_rescaled)) {
#   for (j in 6:10) {
#     acc_curr_pos[i] <- acc_curr_pos[i] + choose(n, j)*acc_by_pos_rescaled[i]^j*(1-acc_by_pos_rescaled[i])^(n - j)
#   }
# }
# #acc <- 1 - sum(1 - acc_curr_pos)
# acc <- cumprod(acc_curr_pos)[length(acc_curr_pos)]

#alternativa:
n <- 10
acc <- 0.88
acc_iter <- 0
for (j in 6:10) {
  acc_iter <- acc_iter + choose(n, j)*acc^j*(1-acc)^(n - j)
}



}
