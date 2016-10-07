--不知火流 輪廻の陣
--Shiranui Style Reincarnation
--Scripted by Eerie Code
function c78765160.initial_effect(c)
	--change code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetValue(40005099)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c78765160.target1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c78765160.target2)
	c:RegisterEffect(e2)
end

function c78765160.ndcfil(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemoveAsCost()
end
function c78765160.ndcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78765160.ndcfil,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():GetFlagEffect(78765160)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c78765160.ndcfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RegisterFlagEffect(78765160,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c78765160.ndop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end

function c78765160.drfil(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:GetDefense()==0 and c:IsAbleToDeck()
end
function c78765160.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(78765160)==0 end
	e:GetHandler():RegisterFlagEffect(78765160,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1) 
end
function c78765160.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c78765160.drfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c78765160.drfil,tp,LOCATION_REMOVED,0,2,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c78765160.drfil,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c78765160.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g or g:FilterCount(Card.IsRelateToEffect,nil,e)~=2 then return end
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==2 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

function c78765160.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local b1=c78765160.ndcost(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c78765160.drcost(e,tp,eg,ep,ev,re,r,rp,0) and c78765160.drtg(e,tp,eg,ep,ev,re,r,rp,0)
	local op=2
	e:SetCategory(0)
	e:SetProperty(0)
	if (b1 or b2) and Duel.SelectYesNo(tp,94) then
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(78765160,0),aux.Stringid(78765160,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(78765160,0))
		else
			op=Duel.SelectOption(tp,aux.Stringid(78765160,1))+1
		end
		if op==0 then
			e:SetCategory(0)
			e:SetProperty(0)
			c78765160.ndcost(e,tp,eg,ep,ev,re,r,rp,1)
			Duel.BreakEffect()
			e:SetOperation(c78765160.ndop)
		else
			e:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH)
			e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
			c78765160.drcost(e,tp,eg,ep,ev,re,r,rp,1)
			c78765160.drtg(e,tp,eg,ep,ev,re,r,rp,1)
			Duel.BreakEffect()
			e:SetOperation(c78765160.drop)
		end
	else
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end

function c78765160.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=c78765160.ndcost(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c78765160.drcost(e,tp,eg,ep,ev,re,r,rp,0) and c78765160.drtg(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(78765160,0),aux.Stringid(78765160,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(78765160,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(78765160,1))+1
	end
	if op==0 then
		e:SetCategory(0)
		e:SetProperty(0)
		c78765160.ndcost(e,tp,eg,ep,ev,re,r,rp,1)
		Duel.BreakEffect()
		e:SetOperation(c78765160.ndop)
	else
		e:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
		c78765160.drcost(e,tp,eg,ep,ev,re,r,rp,1)
		c78765160.drtg(e,tp,eg,ep,ev,re,r,rp,1)
		Duel.BreakEffect()
		e:SetOperation(c78765160.drop)
	end
end
