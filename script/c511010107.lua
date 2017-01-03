--No.107 銀河眼の時空竜 (Anime)
--fixed and cleaned up by MLD
function c511010107.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(c511010107.regcon)
	e1:SetOperation(c511010107.regop)
	c:RegisterEffect(e1)
	--negate opponent's turn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511010107,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c511010107.negcono)
	e2:SetCost(c511010107.negcost)
	e2:SetTarget(c511010107.negtg)
	e2:SetOperation(c511010107.negop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e3:SetDescription(aux.Stringid(511010107,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c511010107.negconp)
	e3:SetCost(c511010107.negcost)
	e3:SetTarget(c511010107.negtg)
	e3:SetOperation(c511010107.negop)
	c:RegisterEffect(e3)
	--battle indestructable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetValue(c511010107.indes)
	c:RegisterEffect(e6)
	if not c511010107.global_check then
		c511010107.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511010107.numchk)
		Duel.RegisterEffect(ge2,0)
	end
end
c511010107.xyz_number=107
function c511010107.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c511010107.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(511010107,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE,0,0)
end
function c511010107.negcono(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c511010107.cfilter(c)
	return c:GetFlagEffect(511010108)>0
end
function c511010107.negconp(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE and Duel.GetTurnPlayer()==tp 
		and not Duel.GetAttacker() and Duel.GetCurrentChain()==0 
		and not Duel.IsExistingMatchingCard(c511010107.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c511010107.ftarget(e,c)
	return c:GetFlagEffect(511010108)==0
end
function c511010107.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	if Duel.GetTurnPlayer()==tp then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_OATH)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c511010107.ftarget)
		e1:SetLabel(e:GetHandler():GetFieldID())
		e1:SetReset(RESET_PHASE+PHASE_BATTLE)
		Duel.RegisterEffect(e1,tp)
	end
end
function c511010107.disfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c511010107.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511010107.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) 
		or e:GetHandler():GetFlagEffect(511010107)>0 end
end
function c511010107.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=false
	local g=Duel.GetMatchingGroup(c511010107.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK_FINAL)
			e3:SetValue(tc:GetBaseAttack())
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e4:SetValue(tc:GetBaseDefense())
			e4:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e4)
			tc=g:GetNext()
		end
		res=true
	end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local ct=c:GetFlagEffect(511010107)
	if ct>0 then
		Duel.BreakEffect()
		local atk=ct*1000
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		res=true
	end
	if Duel.GetTurnPlayer()==tp and res then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetValue(c:GetAttackAnnouncedCount())
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(511010108,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE+PHASE_BATTLE,0,0)
	end
end
function c511010107.numchk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,88177324)
	Duel.CreateToken(1-tp,88177324)
end
function c511010107.indes(e,c)
	return not c:IsSetCard(0x48)
end
